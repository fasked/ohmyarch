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
efibootmgr --disk /dev/sda --part 1 --create --label "Arch Linux" --loader /vmlinuz-linux --unicode "root=UUID=$(blkid -s UUID -o value /dev/sda2) rw initrd=\initramfs-linux.img" --verbose

# Create users
ARCH_USER="fasked"
useradd -m $ARCH_USER
echo -e "my_default_password" | passwd $ARCH_USER

# Install xorg and plasma
pacman -S xorg-xinit xorg-server 
pacman -S plasma-desktop plasma-nm

# Install develop packages
pacman -S base-devel fish openssh vim git subversion docker qtcreator postgresql-libs

# Install misc
pacman -S pacman-contrib chromium ark filelight konsole kate kcalc kwrite kruler kcolorchooser gwenview okular spectacle svgpart 

# Configure startx
echo "exec startplasma-x11" > /home/$ARCH_USER/.xinitrc

# Enable NetworkManager
systemctl enable NetworkManager.service

# Enable docker
systemctl enable docker.service

# Set fish as default shell
chsh --shell /usr/bin/fish $ARCH_USER

