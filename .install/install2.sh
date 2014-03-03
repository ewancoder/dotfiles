#!/bin/bash
echo
echo Arch linux CHROOT installation script by Ewancoder
echo Version: 1.0, 2014
echo Run this script after you chroot in /mnt
echo

grep -B 0 -C 2 "6:" install.txt

echo "-> ln -s /usr/share/zoneinfo/Europe/Minsk /etc/localtime"
ln -s /usr/share/zoneinfo/Europe/Minsk /etc/localtime
echo

grep -B 0 -C 2 "7:" install.txt

echo "-> echo ewanhost > /etc/hostname"
echo ewanhost > /etc/hostname
echo

grep -B 0 -C 2 "8:" install.txt

echo "-> passwd (setup ROOT password) [MANUAL]"
passwd
echo

grep -B 0 -C 7 "9:" install.txt

echo "-> pacman -S grub"
pacman -S grub
echo

echo "-> grub-install --target=i386-pc --recheck /dev/sd? (choose disk)"
select abcd in "/dev/sda" "/dev/sdb" "/dev/sdc" "/dev/sdb"; do
    case $abcd in 
        /dev/sda ) grub-install --target=i386-pc --recheck /dev/sda; break;;
        /dev/sdb ) grub-install --target=i386-pc --recheck /dev/sdb; break;;
        /dev/sdc ) grub-install --target=i386-pc --recheck /dev/sdc; break;;
        /dev/sdd ) grub-install --target=i386-pc --recheck /dev/sdb; break;;
    esac
done

echo "-> pacman -S os-prober"
pacman -S os-prober
echo

echo "-> grub-mkconfig -o /boot/grub/grub.cfg"
grub-mkconfig -o /boot/grub/grub.cfg
echo

grep -B 0 -C 3 "10:" install.txt

echo "-> rm install* && mv post* /root/"
rm install* && mv {post,merge}* /root/
echo

read -p "After exitting, reboot onto fresh system and run postinstall.sh. You should exit manually from chroot!"
echo "-> exit"
exit
