#!/bin/bash
echo
echo Arch linux installation script by Ewancoder
echo Version: 1.0, 2014
echo

read -p "-> Download ALL files: install.txt, postinstall.txt, install.sh, install2.sh, postinstall.sh, postinstall2.sh"
curl -O https://raw.github.com/ewancoder/dotfiles/master/.install/install.txt
curl -O https://raw.github.com/ewancoder/dotfiles/master/.install/postinstall.txt
curl -O https://raw.github.com/ewancoder/dotfiles/master/.install/install.sh
curl -O https://raw.github.com/ewancoder/dotfiles/master/.install/install2.sh
curl -O https://raw.github.com/ewancoder/dotfiles/master/.install/postinstall.sh
curl -O https://raw.github.com/ewancoder/dotfiles/master/.install/postinstall2.sh
echo

read -p "-> Make all scripts executable: chmod +x *.sh"
chmod +x *.sh
echo

grep -B 0 -C 6 "Current PT:" install.txt
grep -B 0 -C 5 "1:" install.txt

echo "-> Use fdisk, mkfs.ext4 and mount to /mnt [MANUAL]"
read -p "-> Press [Enter] when all done..."
echo

read -p "-> cp post* /mnt/ && cp install* /mnt/"
cp post* /mnt/ && cp install* /mnt/
echo

grep -B 0 -C 3 "2:" install.txt

read -p "-> vi /etc/pacman.d/mirrorlist (move belarus on the first place) [MANUAL]"
vi /etc/pacman.d/mirrorlist
echo

read -p "-> pacman -Syy"
pacman -Syy
echo

grep -B 0 -C 3 "3:" install.txt

read -p "-> pacstrap -i /mnt base base-devel"
pacstrap -i /mnt base base-devel
echo

grep -B 0 -C 7 "4:" install.txt

read -p "-> genfstab -U -p /mnt >> /mnt/etc/fstab"
genfstab -U -p /mnt >> /mnt/etc/fstab
echo

read -p "-> vi /mnt/etc/fstab (add 'discard' option, comment /boot) [MANUAL]"
vi /mnt/etc/fstab
echo

grep -B 0 -C 2 "5:" install.txt

echo "After chroot this script will be shut down, you now gotta run install2.sh from chroot environment"
read -p "-> arch-chroot /mnt /bin/bash"
arch-chroot /mnt /bin/bash
echo
echo "You've completed the installation. After reboot you need to run postinstall.sh for quick all system autoconfiguration."

read -p "-> umount -R /mnt"
umount -R /mnt
echo

read -p "reboot"
reboot
