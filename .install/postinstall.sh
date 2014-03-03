#!/bin/bash
echo
echo Arch linux post-installation script by Ewancoder
echo Version: 1.0, 2014
echo

#Constants
netctl=no
username=ewancoder

grep -B 0 -C 11 "1:  Configure network" postinstall.txt

if [ $netctl -eq yes ]
then
    echo "-> See /sys/class/net interfaces"
    ls -la /sys/class/net
    echo

    echo "-> Get ethernet-static template"
    cp /etc/netctl/examples/ethernet-static /etc/netctl/
    echo

    read -p "-> Configure network (edit ethernet-static file)"
    vi /etc/netctl/ethernet-static
    echo

    echo "-> Enable and start netctl ethernet-static"
    netctl enable ethernet-static
    netctl start ethernet-static
    echo
else
    echo "-> Temporary start DHCP service"
    dhcpcd
    echo
fi

grep -B 0 -C 4 "2:  Add new user" postinstall.txt

echo "-> Add group 'fuse'"
groupadd fuse
echo

echo "-> Add user $username"
useradd -m -g users -G fuse -s /bin/bash $username

grep -B 0 -C 6 "3:  Install sudo" postinstall.txt

echo "-> Install sudo"
pacman -S --noconfirm sudo
echo

echo "-> Edit (visudo) sudoers file via awk"
awk '/root ALL/{print;print "'$username' ALL=(ALL) ALL";next}1' /etc/sudoers > lsudoers
mv lsudoers /etc/sudoers
echo

echo "-> mv postinstall2.sh postinstall.txt /home/$username/ && rm post*"
mv postinstall2.sh postinstall.txt mergeinstall.sh /home/$username/ && rm post*
echo

echo "-> Setup your user ($username) password"
passwd $username
echo

echo "-> Please, run postinstall2.sh script as user $username to continue"
exit
