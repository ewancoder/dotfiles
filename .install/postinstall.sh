#!/bin/bash
echo
echo Arch linux post-installation script by Ewancoder
echo Version: 1.0, 2014
echo

grep -B 0 -C 6 "Current PT:" install.txt

echo "-> Use fdisk, mkfs.ext4 and mount to /mnt [MANUAL]"
read -p "-> Press [Enter] when all done..."
echo

