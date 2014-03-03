#!/bin/bash
echo
echo Arch linux CHROOT installation script by Ewancoder
echo Version: 1.0, 2014
echo Run this script after you chroot in /mnt
echo

#Constants
hostname=ewanhost
device=/dev/sda
clearfstab=no

grep -B 0 -C 2 "6:" install.txt
echo "-> Make link to local timezone (Minsk)"
ln -s /usr/share/zoneinfo/Europe/Minsk /etc/localtime
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
