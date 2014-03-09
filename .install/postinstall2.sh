#ry of processors!/bin/bash
echo
echo Arch linux post-installation 2nd script by Ewancoder
echo Version: 1.0, 2014
echo

pasetup=$1
winfonts=$2

grep -B 0 -C 13 "4:  Install yaourt" postinstall.txt

echo "Download package-query.tar.gz file"
curl -O https://aur.archlinux.org/packages/pa/package-query/package-query.tar.gz
echo

echo "tar xvf package-query.tar.gz"
tar xvf package-query.tar.gz
echo

echo "cd package-query"
cd package-query
echo

echo "makepkg -s"
makepkg -s --noconfirm
echo

echo "#pacman -U *.xz"
sudo pacman -U --noconfirm *.xz
echo

echo "Download yaourt.tar.gz file"
curl -O https://aur.archlinux.org/packages/ya/yaourt/yaourt.tar.gz
echo

echo "tar xvf yaourt.tar.gz"
tar xvf yaourt.tar.gz
echo

echo "cd yaourt"
cd yaourt
echo

echo "makepkg"
makepkg --noconfirm
echo

echo "#pacman -U *.xz"
sudo pacman -U --noconfirm *.xz
echo

echo "cd && rm -r package-query*"
cd && rm -r package-query*
echo

grep -B 0 -C 11 "5:  Install git and download repos" postinstall.txt

echo "-> yaourt -S git"
sudo rm /var/lib/pacman/db.lck
yaourt -S --noconfirm git
echo

echo "-> git config --global user.name ewancoder"
git config --global user.name ewancoder
echo

echo "-> git config --global user.email ewancoder@gmail.com"
git config --global user.email ewancoder@gmail.com
echo

echo "-> git config --global merge.tool vimdiff"
git config --global merge.tool vimdiff
echo

echo "-> git config --global core.editor vim"
git config --global core.editor vim
echo

echo "-> #ln -s ~/.gitconfig /root/"
sudo ln -s ~/.gitconfig /root/
echo

echo "-> git clone https://github.com/ewancoder/dotfiles.git .dotfiles"
git clone https://github.com/ewancoder/dotfiles.git .dotfiles
echo

echo "-> sudo git clone https://github.com/ewancoder/etc.git /etc/.dotfiles"
sudo git clone https://github.com/ewancoder/etc.git /etc/.dotfiles
echo

echo "-> cd .dotfiles && git submodule update --init --recursive .oh-my-zsh .vim/bundle/vundle"
cd .dotfiles && git submodule update --init --recursive .oh-my-zsh .vim/bundle/vundle
echo

echo "-> mkdir .vim/{swap,backup} && cd"
mkdir .vim/{swap,backup}
cd
echo

grep -B 0 -C 14 "6:" postinstall.txt

echo "-> MERGE ALL GIT LINKS: Now will be executed script that will merge all git links from ~/.dotfiles & from /etc/.dotfiles"
./mergeinstall.sh
echo "-> All links have been merged"
echo

echo "-> #grub-mkconfig -o /boot/grub/grub.cfg"
sudo grub-mkconfig -o /boot/grub/grub.cfg
echo

echo "-> #locale-gen"
sudo locale-gen
echo

echo "-> Setup gvim for root (links for .vim & .vimrc)"
sudo ln -s ~/.vim /root/.vim
sudo ln -s ~/.vimrc /root/.vimrc
echo

echo "-> change password in config file [MANUAL]"
cp ~/.irssi/config_sample ~/.irssi/config
vim ~/.irssi/config
echo

echo "-> setfont cyr-sun16"
setfont cyr-sun16
echo

echo "-> yaourt -Syy"
yaourt -Syy
echo

grep -B 0 -C 12 "7:" postinstall.txt

echo "-> yaourt -S alsa-plugins alsa-utils pulseaudio pulseaudio-alsa lib32-libpulse lib32-alsa-plugins"
yaourt -S --noconfirm alsa-plugins alsa-utils pulseaudio pulseaudio-alsa lib32-libpulse lib32-alsa-plugins
echo

if [ $pasetup = yes ]
then
    echo "-> pulseaudio --start"
    pulseaudio --start
    echo

    read -p "-> Setup standart devices: pactl list | less"
    pactl list | less
    echo

    read -p "-> pacmd set-default-sink 1"
    select num in "1" "2" "3" "4" "5" "6";
    do
        case $num in
            1 ) pacmd set-default-sink 1; break;;
            2 ) pacmd set-default-sink 2; break;;
            3 ) pacmd set-default-sink 3; break;;
            4 ) pacmd set-default-sink 4; break;;
            5 ) pacmd set-default-sink 5; break;;
            6 ) pacmd set-default-sink 6; break;;
            7 ) pacmd set-default-sink 7; break;;
        esac
    done
    echo

    read -p "-> pacmd set-default-source 1"
    select num in "1" "2" "3" "4" "5" "6";
    do
        case $num in
            1 ) pacmd set-default-source 1; break;;
            2 ) pacmd set-default-source 2; break;;
            3 ) pacmd set-default-source 3; break;;
            4 ) pacmd set-default-source 4; break;;
            5 ) pacmd set-default-source 5; break;;
            6 ) pacmd set-default-source 6; break;;
            7 ) pacmd set-default-source 7; break;;
        esac
    done
    echo
fi

if [ $winfonts = yes ]
then
    grep -B 0 -C 5 "8:" postinstall.txt

    echo "-> Mount windows partitions to /mnt/windows [MANUAL]"
    read -p "-> Press [ENTER] when done..."
    echo

    echo "-> cp -r /mnt/windows/Windows/Fonts /usr/share/fonts/winfonts"
    cp -r /mnt/windows/Windows/Fonts /usr/share/fonts/winfonts
    echo
fi

echo "-> sudo fc-cache -fv"
fc-cache -fv
echo

grep -B 0 -C 2 "9:" postinstall.txt

echo "-> Fix dead acute error in Compose-keys X11 file :)"
sudo sed -i "s/dead actute/dead acute/g" /usr/share/X11/locale/en_US.UTF-8/Compose
echo

echo "Installing core software..."
yaourt -S libreoffice nvidia-libgl lib32-libgl nvidia

#mesa-libgl <---> nvidia-libgl

#lib32-nvidia-libgl <- nvidia package in multilib
#not nvidia, but xf86-video-nouveau + lib32-nouveau-dri
yaourt -S --noconfirm anki canto chromium chromium-libpdf chromium-pepper-flash icedtea-web-java7 djview4 deluge dropbox dunst faience-icon-theme feh fuse ntfs-3g encfs geeqie gimp gource gvim irssi kalu hyphen hyphen-ru hyphen-en hunspell hunspell-ru hunspell-en mesa openssh p7zip perl-html-parser preload python-matplotlib python-numpy python-scipy python-sphinx rxvt-unicode screen scrot skype terminus-font thunar tig transset-df ttf-dejavu vlc xorg-server xorg-server-utils xorg-xinit wmii-hg xarchiver xclip xcompmgr xfe zsh
echo

echo "-> #rm *install*"
sudo rm *install*
echo
exit
