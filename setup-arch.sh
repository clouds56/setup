#!/usr/bin/zsh

# https://wiki.archlinux.org/index.php/USB_flash_installation_media
#dd bs=4M if=/path/to/archlinux.iso of=/dev/sdX status=progress && sync

# https://wiki.archlinux.org/index.php/Installation_guide
timedatectl set-ntp true
# https://wiki.archlinux.org/index.php/time#UTC_in_Windows
#reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_DWORD /f
gdisk
# esp 1G ef00
# root 200G 8304
# home 500G 8302
# swap 50G 8200
# w && q
mkfs.fat /dev/sda1
mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/sda3
mkswap /dev/sda4
#lsblk

mount /dev/sda2 /mnt
mkdir /mnt/home
mount /dev/sda3 /mnt/home
mkdir /mnt/esp
mount /dev/sda1 /mnt/esp
mkdir -p /mnt/esp/EFI/Arch
mkdir /mnt/boot
mount --bind /mnt/esp/EFI/Arch /mnt/boot
#genfstab /mnt

vim /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel

genfstab -U /mnt | sed "s|/mnt||" >> /mnt/etc/fstab
arch-chroot /mnt

rm /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc
vim /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo Clouds-P3 >> /etc/hostname
exit

bootctl --path=/mnt/esp install
vim /mnt/esp/loader/entries/arch.conf
# title   Arch Linux
# linux   /EFI/Arch/vmlinuz-linux
# initrd  /EFI/Arch/initramfs-linux.img
# options root=PARTUUID= rw
sed -i "s|PARTUUID=|\0`blkid -s PARTUUID -o value /dev/sda2`|" /mnt/esp/loader/entries/arch.conf

umount -R /mnt
reboot

systemctl enable dhcpcd
systemctl start dhcpcd
pacman -S zsh grml-zsh-config
# https://wiki.archlinux.org/index.php/Users_and_groups
useradd -m -G wheel -s /bin/zsh clouds
passwd clouds
visudo
exit

# https://wiki.archlinux.org/index.php/Xorg
sudo pacman -S xorg-server xorg-xinit xorg-xinput
sudo pacman -S xf86-video-fbdev xf86-video-intel
sudo pacman -S xf86-input-mouse xf86-input-keyboard
sudo pacman -S xorg-drivers xorg xorg-server-utils
# sudo pamcna -S lomoco
# https://wiki.archlinux.org/index.php/Wayland
# https://bbs.archlinux.org/viewtopic.php?id=214569
sudo pacman -S xorg-server-xwayland qt5-wayland wayland-protocols
# https://wiki.archlinux.org/index.php/KDE
sudo pacman -S plasma
