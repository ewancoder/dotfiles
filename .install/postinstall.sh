#!/bin/bash
echo
echo Arch linux post-installation script by Ewancoder
echo Version: 1.0, 2014
echo

grep -B 0 -C 11 "1:  Configure network" postinstall.txt

echo "-> ls -la /sys/class/net"
ls -la /sys/class/net
echo

echo "-> cp /etc/netctl/examples/ethernet-static /etc/netctl/"
cp /etc/netctl/examples/ethernet-static /etc/netctl/
echo

read -p "-> Configure network: vi /etc/netctl/ethernet-static [MANUAL]"
vi /etc/netctl/ethernet-static
echo

echo "-> netctl enable ethernet-static"
netctl enable ethernet-static
echo

echo "-> netctl start ethernet-static"
netctl start ethernet-static
echo

grep -B 0 -C 4 "2:  Add new user" postinstall.txt

echo "-> groupadd fuse"
groupadd fuse
echo

echo "-> useradd -m -g users -G fuse -s /bin/bash ewancoder"
useradd -m -g users -G fuse -s /bin/bash ewancoder

grep -B 0 -C 6 "3:  Install sudo" postinstall.txt

echo "-> pacman -S sudo"
pacman -S --noconfirm sudo
echo

read -p "-> visudo [MANUAL]"
visudo
echo

echo "-> passwd ewancoder [Setup your password]"
passwd ewancoder
echo

echo "-> mv postinstall2.sh postinstall.txt /home/ewancoder/ && rm post*"
mv postinstall2.sh postinstall.txt mergeinstall.sh /home/ewancoder/ && rm post*
echo

read -p "After exitting, login as user and run postinstall2.sh to continue. Exit manually!"
echo "-> exit"
exit
