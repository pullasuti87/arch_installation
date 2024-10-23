#!/bin/bash

# NEEDS MORE TESTING!!

print_step() {
    echo "==> $1"
}

get_input() {
    local prompt="$1"
    local default="$2"
    read -p "$prompt [$default]: " value
    echo "${value:-$default}"
}

# change these
print_step "variables"
DISK=$(get_input "disk name" "???")
DISK_PATH="/dev/$DISK"
USERNAME=$(get_input "enter username:" "???")
TIMEZONE=$(get_input "enter timezone:" "Europe/Helsinki")
LOCALE=$(get_input "enter locale:" "en_US.UTF-8")

print_step "larger font"
setfont -d

print_step "setting fi keys"
loadkeys fi

# wifi
print_step "sestting up wifi"
echo "available wifi:"
iwctl device list
read -p "wifi name: " WIFI_DEVICE
echo "available networks:"
iwctl station "$WIFI_DEVICE" get-networks
read -p "network name: " WIFI_NETWORK
iwctl station "$WIFI_DEVICE" connect "$WIFI_NETWORK"

# internet connection
print_step "check connection..."
ping -c 3 iltalehti.fi

# partitions
print_step "creating partitions..."
# warning
echo "will erase all data on $DISK_PATH"
read -p "continue? (y/N) " confirm
[[ $confirm == [yY] ]] || exit 1

# partition table and partitions
(
echo g # new gpt partition table
echo n # new partition
echo   # use default
echo   # use default
echo +550M # boot size
echo t # change partition type
echo 1 # efi

echo n # new partition
echo   # default
echo   # default
echo   # default last sector, uses rest disk space

echo w # write changes
) | fdisk "$DISK_PATH"

# format partitions
print_step "formatting partitions..."
EFI_PARTITION="${DISK_PATH}1"
ROOT_PARTITION="${DISK_PATH}2"

mkfs.fat -F32 "$EFI_PARTITION"
mkfs.ext4 "$ROOT_PARTITION"

# oount partitions
print_step "mounting partitions..."
mount "$ROOT_PARTITION" /mnt
mkdir -p /mnt/boot
mount "$EFI_PARTITION" /mnt/boot

# packages
print_step "install packages"
pacstrap /mnt base linux linux-firmware networkmanager efibootmgr grub vim

# fstab
print_step "creating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

# new os
print_step "new system"
arch-chroot /mnt /bin/bash <<EOT

ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc

echo "$LOCALE UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=$LOCALE" > /etc/locale.conf

# keyboard
echo "KEYMAP=fi" > /etc/vconsole.conf

systemctl enable NetworkManager

# grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# amd drivers
pacman -S --noconfirm amd-ucode mesa xf86-video-amdgpu

echo "root password:"
passwd

useradd -m "$USERNAME"
echo "password for $USERNAME:"
passwd "$USERNAME"
usermod -aG wheel,audio,video,storage "$USERNAME"
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers.d/wheel

EOT

print_step "installation complete!!"
umount -R /mnt

# reboot
read -p "reboot now? (y/N) " reboot_response
if [[ $reboot_response =~ ^[Yy]$ ]]; then
    reboot
else
    echo "no reboot, installation completed"
fi

