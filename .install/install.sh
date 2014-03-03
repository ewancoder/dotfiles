#!/bin/bash
echo
echo Arch linux installation script by Ewancoder
echo Version: 1.0, 2014
echo

echo "-> Download ALL files"
curl -O https://raw.github.com/ewancoder/dotfiles/master/.install/install.txt
curl -O https://raw.github.com/ewancoder/dotfiles/master/.install/postinstall.txt
curl -O https://raw.github.com/ewancoder/dotfiles/master/.install/install2.sh
curl -O https://raw.github.com/ewancoder/dotfiles/master/.install/postinstall.sh
curl -O https://raw.github.com/ewancoder/dotfiles/master/.install/postinstall2.sh
curl -O https://raw.github.com/ewancoder/dotfiles/master/.install/mergeinstall.sh
echo

grep -B 0 -C 6 "Current PT:" install.txt
grep -B 0 -C 4 "1:" install.txt
read -p "Before executing script, MAKE SURE that you've mounted your partitions to /mnt and formatted them as needed (fdisk + mkfs.ext4 + mount). Continue [ENTER]"
echo

grep -B 0 -C 3 "2:" install.txt
echo "-> Move Belarus to the first place"
grep -B 0 -C 1 Belarus /etc/pacman.d/mirrorlist > mirrorlist
grep -B 0 -C 1 United /etc/pacman.d/mirrorlist >> mirrorlist
grep -B 0 -C 1 Denmark /etc/pacman.d/mirrorlist >> mirrorlist
grep -B 0 -C 1 France /etc/pacman.d/mirrorlist >> mirrorlist
grep -B 0 -C 1 Russia /etc/pacman.d/mirrorlist >> mirrorlist
mv mirrorlist /etc/pacman.d/mirrorlist
echo

echo "-> Make scripts executable"
chmod +x *.sh
echo

echo "-> Copy scripts&guides to /mnt"
cp *install* /mnt/
echo

echo "-> Update pacman packages list"
pacman -Syy
echo

grep -B 0 -C 3 "3:" install.txt
echo "-> Install base-system"
pacstrap /mnt base base-devel
echo

grep -B 0 -C 7 "4:" install.txt
echo "-> Generate fstab"
genfstab -U -p /mnt >> /mnt/etc/fstab
echo

grep -B 0 -C 2 "5:" install.txt
echo "-> Go to chroot"
arch-chroot /mnt /install2.sh

read -p "After reboot run ./postinstall to continue [reboot]"
echo "-> reboot"
reboot
