# notes for arch installation (laptop, wifi)

- help
> - double font size: setfont -d
> - fi keys, loadkeys fi

- for wifi, use iwactl
> - device list
> - station (device) get-networks
> - station (device) connect (network)
> - test: ping (net address)

- partitions, needed efi, root, swap (optional)
> - fdisk -l
> - fdisk /dev/(disk name)
> - partition table, press g, uefi
> - press n, create new partition, default values
> - set last sector +550M
> - press t, change to efi system type 1
> - press n, , create new partition, default values
> - leave empty, uses all remaining space
> - if swap, then same, usually 1.5 to ram
> - press t, change to type 19

- format
> - efi: mkfs.fat -F32 /dev/(partition name)
> - root: mkfs.ext4 /dev/(partition name)
> - swap: mkswap /dev/(swap namw)

- mount
> - root: /dev/(name) /mnt
> - efi:  mkdir /mnt/boot && mount /dev/(name) /mnt/boot
> - swap: swapon /devr/(name)

- must have packages
> - pacstrap /mnt base linux linux-firmware networkmanager efibootmgr grub vim

- fstab
> - genfstab -U /mnt >> /mnt/etc/fstab

- chroot
> - arch-chroot /mnt

- timezone
> - timedatectl list-timezones
> - timedatectl set-timezone (timezone)

- localization
> - vim /etc/locale.gen, uncomment right locale
> - locale-gen

- network
> - systemctl enable NetworkManager (use nmtui to configure)

- keyboard
> - vim /etc/vconsole.conf
> - KEYMAP=fi

- grub
> - grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
> - grub-mkconfig -o /boot/grub/grub.cfg

- drivers
> - pacman -S amd-ucode,  mesa xf86-video-amdgpu

- root
> - passwd

- add user
> - useradd -m (name)
> - passwd (name)
> - usermod -aG wheel,audio,video,storage username
> - EDITOR=vim visudo, uncomment %wheel ALL=(ALL) ALL

- end
> - exit
> - umount -R /mnt
> - reboot

### END OF INSTALLATION (bare bone)

- packages
> - sway, window manager
> - foot, terminal
> - wofi, app launcher
> - wl-clipboard, clipbord for vim
> - wlsunset, night light
> - brightnessctl, adjust screen
> - pulseaudio pulseaudio-alsa alsa-utils, sound
> - pavucontrol, volume control
> - unzip







