#!/bin/bash
# Assuming running on Ubuntu/Debian
# This script should be run with sudo

export DEBIAN_FRONTEND=noninteractive
type unzip > /dev/null || sudo apt install unzip
pwd | grep 'Unbox-main' > /dev/null || (
touch '/tmp/unbox.lock' wget https://github.com/keystroke3/unbox/archive/refs/heads/main.zip -O /tmp/unbox.zip &&
unzip /tmp/unbox.zip &&
cd Unbox-main)
sudo apt update && sudo apt upgrade
packages=("zsh" "nginx" "certbot" "python3-certbot-nginx" "exa" "postgresql" "ripgrep" "fd-find" "fzf" "python3-virtualenv" "sqlite3" "webp" "redis" "net-tools" "python3-pip" "libpangocairo-1.0-0" "htop" "man" "neovim")
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

mkdir /tmp/zsh
wget https://github.com/zsh-users/zsh-autosuggestions/archive/refs/heads/master.zip -O /tmp/zsh/suggestions.zip
unzip /tmp/zsh/suggestions.zip
mv zsh-autosuggestions-master $zdir/zsh-autosuggestions

wget https://github.com/zsh-users/zsh-syntax-highlighting/archive/refs/heads/master.zip -O /tmp/zsh/highlighting.zip
unzip /tmp/zsh/highlighting.zip
mv zsh-syntax-highlighting-master $zdir/zsh-syntax-highlighting

wget https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv/archive/refs/heads/master.zip -O /tmp/zsh/switchenv.zip
unzip /tmp/zsh/switchenv.zip
mv zsh-autoswitch-virtualenv-master $zdir/zsh-autoswitch-virtualenv

rm -r /tmp/zsh

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

[ -f '/tmp/unzip.lock' ] && cd - && rm -r Unbox-main && rm '/tmp/unbox.lock'
