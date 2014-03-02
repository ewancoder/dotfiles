#!/bin/bash
echo Arch linux CHROOT installation script by Ewancoder
echo Version: 1.0, 2014
echo Run this script after you chroot in /mnt
echo

grep -B 0 -C 2 "6:" /home/install.txt

read -p "-> ln -s /usr/share/zoneinfo/Europe/Minsk /etc/localtime"
ln -s /usr/share/zoneinfo/Europe/Minsk /etc/localtime
echo

grep -B 0 -C 2 "7:" /home/install.txt

read -p "-> echo ewanhost > /etc/hostname"
echo ewanhost > /etc/hostname
echo

grep -B 0 -C 2 "8:" /home/install.txt

read -p "-> passwd (setup your password) [MANUAL]"
passwd
echo

grep -B 0 -C 7 "9:" /home/install.txt

read -p "-> pacman -S grub"
pacman -S grub
echo

read -p "-> grub-install --target=i386-pc --recheck /dev/sd? (choose disk)"
select abcd in "/dev/sda" "/dev/sdb" "/dev/sdc" "/dev/sdb"; do
    case $abcd in 
        /dev/sda ) grub-install --target=i386-pc --recheck /dev/sda; break;;
        /dev/sdb ) grub-install --target=i386-pc --recheck /dev/sdb; break;;
        /dev/sdc ) grub-install --target=i386-pc --recheck /dev/sdc; break;;
        /dev/sdd ) grub-install --target=i386-pc --recheck /dev/sdb; break;;
    esac
done

read -p "-> pacman -S os-prober"
pacman -S os-prober
echo

read -p "-> grub-mkconfig -o /boot/grub/grub.cfg"
grub-mkconfig -o /boot/grub/grub.cfg
echo

grep -B 0 -C 3 "10:" /home/install.txt

read -p "-> rm /home/install.txt"
rm /home/install.txt
echo

echo "After exitting, reboot onto fresh system and run postinstall.sh from /home directory"
read -p "-> exit"
echo
