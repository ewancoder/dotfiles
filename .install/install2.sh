#!/bin/bash
echo
echo Arch linux CHROOT installation script by Ewancoder
echo Version: 1.0, 2014
echo Run this script after you chroot in /mnt
echo

#Constants
timezone=Europe/Minsk   #Your local timezone
hostname=ewanhost       #Your hosname of the machine
device=/dev/sda         #Device to install grub mbr
clearfstab=yes          #If 'yes', you will not be prompted to edit fstab

grep -B 0 -C 2 "6:" install.txt
echo "-> Make link to local timezone (Minsk)"
ln -s /usr/share/zoneinfo/$timezone /etc/localtime
echo

grep -B 0 -C 2 "7:" install.txt
echo "-> Set hostname"
echo $hostname > /etc/hostname
echo

grep -B 0 -C 7 "9:" install.txt
echo "-> Install grub"
pacman -S --noconfirm grub
echo

echo "-> Install grub to mbr"
grub-install --target=i386-pc --recheck $device
echo

echo "-> Install os-prober"
pacman -S --noconfirm os-prober
echo

echo "-> Make grub config"
grub-mkconfig -o /boot/grub/grub.cfg
echo

grep -B 0 -C 3 "10:" install.txt
echo "-> Move scripts&guides to /root"
rm install* && mv {post,merge}* /root/
echo

echo "-> passwd (setup ROOT password) [MANUAL]"
passwd
echo

if [ clearfstab != yes ]
then
    read -p "-> Edit fstab - add 'discard' (ssd), comment /boot [MANUAL]"
    vi /etc/fstab
    echo
fi
exit
