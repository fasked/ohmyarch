#!/usr/bin/env bash

# The connection may be verified with ping
ping -c4 archlinux.org

# Update the system clock
timedatectl set-ntp true
timedatectl status

# Partition the disks
sfdisk /dev/sda << EOF
    start=2048, size=1048576, type=ef, bootable
    type=83
EOF

# Format the partitions
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

# Install and configure
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

