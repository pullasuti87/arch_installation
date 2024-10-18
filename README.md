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
> -

- format
> - efi: mkfs.fat -F32 /dev/(partition name)
> - root: mkfs.ext4 /dev/(partition name)
> - swap: mkswap /dev/(swap namw)

- mount
> - root: /dev/(name) /mnt
> - efi:  mkdir /mnt/boot && mount /dev/(name) /mnt/boot
> - swap: swapon /devr/(name)

- must have packages
> - pacstrap /mnt base linux linux-firmware networkmanager vim

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
