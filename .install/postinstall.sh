#!/bin/bash
echo
echo Arch linux post-installation script by Ewancoder
echo Version: 1.0, 2014
echo

grep -B 0 -C 11 "1:" /home/postinstall.txt

read -p "-> ls -la /sys/class/net"
ls -la /sys/class/net
echo

read -p "-> cp /etc/netctl/examples/ethernet-static /etc/netctl/"
cp /etc/netctl/examples/ethernet-static /etc/netctl/
echo

read -p "-> vi /etc/netctl/ethernet-static"
vi /etc/netctl/ethernet-static
echo

read -p "-> netctl enable ethernet-static"
netctl enable ethernet-static
echo

read -p "-> netctl start ethernet-static"
netctl start ethernet-static
echo

grep -B 0 -C 4 "2:" /home/postinstall.txt

read -p "-> groupadd fuse"
groupadd fuse
echo

read -p "-> useradd -m -g users -G fuse -s /bin/bash ewancoder"
useradd -m -g users -G fuse -s /bin/bash ewancoder

grep -B 0 -C 6 "3:" /home/postinstall.txt

read -p "-> pacman -S sudo"
pacman -S sudo
echo

read -p "-> visudo"
visudo
echo

read -p "-> passwd ewancoder"
passwd ewancoder
echo

echo "After exitting, login as user and run postinstall2.sh to continue."
read -p "-> exit"
exit
