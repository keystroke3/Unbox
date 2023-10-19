#!/bin/bash
# Assuming running on Ubuntu/Debian
# This script should be run with sudo

export DEBIAN_FRONTEND=noninteractive
sudo apt update && sudo apt upgrade
packages=("zsh" "nginx" "certbot" "python3-certbot-nginx" "exa" "postgresql" "ripgrep" "fd-find" "fzf" "python3-virtualenv" "sqlite3" "webp" "redis" "unzip" "net-tools" "python3-pip" "libpangocairo-1.0-0")
dots=(".aliases" ".vim" ".zshrc")
user_home=$(getent passwd $SUDO_USER | cut -d: -f6)
echo '***** Setting up ZSH ****'
for dot in ${dots[@]}
do
	cp -rs "$(pwd)/$dot" "$user_home/$dot"
    sudo chown $SUDO_USER:$SUDO_USER $dot
done
for pkg in ${packages[@]}
do
	sudo apt-get install -y $pkg
done
echo '***** Setting up ZSH ****'
zdir="$user_home/.zsh"
[ -d $zdir ] && rm $zdir
mkdir $zdir
echo "$user_home" > "$zdir/lastdir"
git clone https://github.com/zsh-users/zsh-autosuggestions $zdir/zsh-autosuggestions
git clone https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv $zdir/zsh-autoswitch-virtualenv
git clone https://github.com/zsh-users/zsh-syntax-highlighting $zdir/zsh-syntax-highlighting
sudo chown $SUDO_USER:$SUDO_USER $user_home/.zsh -R
sudo sh -c "$(curl -fsSL https://starship.rs/install.sh)"
sudo usermod -s /bin/zsh $SUDO_USER
sudo chown -R $SUDO_USER:$SUDO_USER $user_home
echo "Enter new hostname or leave blank to keep $HOST: "
read newhost
if [ ! -z $newhost ]
then
	sudo echo $newhost > /etc/hostname
fi

