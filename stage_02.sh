#!/usr/bin/env bash
# Should be execute in chrooted env

ln -sf /usr/share/zoneinfo/Europe/Samara /etc/localtime
hwclock --systohc

echo "LANG=en_US.UTF-8" > /etc/locale.conf
sed -i '/#en_US.UTF-8/s/^#//g' /etc/locale.gen
locale-gen

echo "nuuk" > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 nuuk"      >> /etc/hosts

# Initramfs
mkinitcpio -P

# Password
echo -e "root_default_password" | passwd 

# Efi
pacman -S efibootmgr
efibootmgr --disk /dev/sda --part 1 --create --label "Arch Linux" --loader /vmlinuz-linux --unicode "root=UUID=$(blkid -s UUID -o value /dev/sda2) rw nvidia-drm.modeset=1 initrd=\amd-ucode.img initrd=\initramfs-linux.img" --verbose

# Create users
ARCH_USER="fasked"
useradd -m -G wheel,audio,network  $ARCH_USER
echo -e "my_default_password" | passwd $ARCH_USER

# Install video
pacman -S xorg-xinit xorg-server 
pacman -S noto-fonts noto-fonts-emoji noto-fonts-cjk
pacman -S nvidia

# Install develop packages
pacman -S base-devel fish openssh nvim git subversion docker gdb postgresql-libs qt5-websockets

# Install WM
pacman -S herbsluftwm rofi alacritty chromium qtcreator

# Install misc
pacman -S pacman-contrib 

# Configure startx
echo "exec /usr/bin/herbsluftwm" > /home/$ARCH_USER/.xinitrc

# Enable NetworkManager
systemctl enable NetworkManager.service

# Set fish as default shell
chsh --shell /usr/bin/fish $ARCH_USER

# AUR packages:
# - pikaur
# - polybar
# - slack
# - zoom
# - disable-c6-systemd
# - reflector-mirrorlist-update
# - ttf-meslo

# install dotfiles
# install ssh and gpg keys

