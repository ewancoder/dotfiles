#!/bin/bash
echo
echo Arch linux post-installation 2nd script by Ewancoder
echo Version: 1.0, 2014
echo

grep -B 0 -C 13 "4:  Install yaourt" postinstall.txt

read -p "Download package-query.tar.gz file"
curl -O https://aur.archlinux.org/packages/pa/package-query/package-query.tar.gz
echo

read -p "tar xvf package-query.tar.gz"
tar xvf package-query.tar.gz
echo

read -p "cd package-query"
cd package-query
echo

read -p "makepkg -s"
makepkg -s
echo

read -p "#pacman -U *.xz"
sudo pacman -U *.xz
echo

read -p "Download yaourt.tar.gz file"
curl -O https://aur.archlinux.org/packages/ya/yaourt/yaourt.tar.gz
echo

read -p "tar xvf yaourt.tar.gz"
tar xvf yaourt.tar.gz
echo

read -p "cd yaourt"
cd yaourt
echo

read -p "makepkg"
makepkg
echo

read -p "#pacman -U *.xz"
sudo pacman -U *.xz
echo

read -p "cd && rm -r package-query*"
cd && rm -r package-query*
echo

grep -B 0 -C 11 "5:  Install git and download repos" postinstall.txt

read -p "-> yaourt -S git"
yaourt -S git
echo

read -p "-> git config --global user.name ewancoder"
git config --global user.name ewancoder
echo

read -p "-> git config --global user.email ewancoder@gmail.com"
git config --global user.email ewancoder@gmail.com
echo

read -p "-> git config --global merge.tool vimdiff"
git config --global merge.tool vimdiff
echo

read -p "-> git config --global core.editor vim"
git config --global core.editor vim
echo

read -p "-> #ln -s ~/.gitconfig /root/"
sudo ln -s ~/.gitconfig /root/
echo

read -p "-> git clone https://github.com/ewancoder/dotfiles.git .dotfiles"
git clone https://github.com/ewancoder/dotfiles.git .dotfiles
echo

read -p "-> sudo git clone https://github.com/ewancoder/etc.git /etc/.dotfiles"
sudo git clone https://github.com/ewancoder/etc.git /etc/.dotfiles
echo

read -p "-> cd .dotfiles && git submodule update --init --recursive .oh-my-zsh .vim/bundle/vundle"
cd .dotfiles && git submodule update --init --recursive .oh-my-zsh .vim/bundle/vundle
echo

read -p "-> mkdir .vim/{swap,backup} && cd"
mkdir .vim/{swap,backup}
cd
echo

grep -B 0 -C 14 "6:" postinstall.txt

read -p "-> MERGE ALL GIT LINKS: Now will be executed script that will merge all git links from ~/.dotfiles & from /etc/.dotfiles"
./mergeinstall.sh
read -p "-> All links have been merged successfully? [RETURN]"
echo

read -p "-> #grub-mkconfig -o /boot/grub/grub.cfg"
sudo grub-mkconfig -o /boot/grub/grub.cfg
echo

read -p "-> #locale-gen"
sudo locale-gen
echo

read -p "-> Setup gvim for root (links for .vim & .vimrc)"
sudo ln -s ~/.vim /root/.vim
sudo ln -s ~/.vimrc /root/.vimrc
echo

read -p "-> change password in config file [MANUAL]"
cp ~/.irssi/config_sample ~/.irssi/config
vim ~/.irssi/config
echo

read -p "-> setfont cyr-sun16"
setfont cyr-sun16
echo

read -p "-> yaourt -Syy"
yaourt -Syy
echo

grep -B 0 -C 12 "7:" postinstall.txt

read -p "-> yaourt -S alsa-plugins alsa-utils pulseaudio pulseaudio-alsa lib32-libpulse lib32-alsa-plugins"
yaourt -S alsa-plugins alsa-utils pulseaudio pulseaudio-alsa lib32-libpulse lib32-alsa-plugins
echo

read -p "-> pulseaudio --start"
pulseaudio --start
echo

read -p "-> pactl list | less"
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

grep -B 0 -C 5 "8:" postinstall.txt

echo "-> Mound windows partition to /mnt/windows [MANUAL]"
read -p "-> Press [ENTER] when done..."
echo

read -p "-> cp -r /mnt/windows/Windows/Fonts /usr/share/fonts/winfonts"
cp -r /mnt/windows/Windows/Fonts /usr/share/fonts/winfonts
echo

read -p "-> fc-cache -fv"
fc-cache -fv
echo

grep -B 0 -C 2 "9:" postinstall.txt

read -p "-> #sed -i 's/dead\sactute/dead\sacute/g' /usr/share/X11/locale/en_US.UTF-8/Compose"
sudo sed -i 's/dead\sactute/dead\sacute/g' /usr/share/X11/locale/en_US.UTF-8/Compose
echo

read -p "Now you gotta install All CORE software. It's big list, and you're going to see it through 'less' right now"
echo

grep -B 0 -C 66 "10:" postinstall.txt | less

read -p "-> yaourt -S anki canto chromium chromium-libpdf chromium-pepper-flash icedtea-web-java7 djview4 deluge dropbox dunst faience-icon-theme feh fuse ntfs-3g encfs geeqie gimp gource gvim irssi kalu libreoffice hyphen hyphen-ru hyphen-en hunspell hunspell-ru hunspell-en mesa nvidia openssh p7zip perl-html-parser preload profile-sync-daemon python-matplotlib python-numpy python-scipy python-sphinx rxvt-unicode screen scrot skype terminus-font thunar tig ttf-dejavu vlc xorg-server xorg-server-utils xorg-xinit wmii-hg xarchiver xclip xcompmgr xfe zsh"
yaourt -S anki canto chromium chromium-libpdf chromium-pepper-flash icedtea-web-java7 djview4 deluge dropbox dunst faience-icon-theme feh fuse ntfs-3g encfs geeqie gimp gource gvim irssi kalu libreoffice hyphen hyphen-ru hyphen-en hunspell hunspell-ru hunspell-en mesa nvidia openssh p7zip perl-html-parser preload profile-sync-daemon python-matplotlib python-numpy python-scipy python-sphinx rxvt-unicode screen scrot skype terminus-font thunar tig ttf-dejavu vlc xorg-server xorg-server-utils xorg-xinit wmii-hg xarchiver xclip xcompmgr xfe zsh
echo

read -p "-> #rm post*"
sudo rm post*
echo

echo "Exec some commands for X after logging in X (see postinstall.txt)"
read -p "-> reboot"
reboot
echo
