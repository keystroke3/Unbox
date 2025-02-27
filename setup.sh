#!/bin/bash
# Assuming running on Ubuntu/Debian
# This script should be run with sudo by a non-root user


# Add or remove packages from this list
packages=("zsh" "ripgrep" "fd-find" "fzf" "nginx" "python3-virtualenv"  "eza" "net-tools" "python3-pip" "libpangocairo-1.0-0" "htop" "man")

# do not modify the code below this point unless you know what you are doing

export DEBIAN_FRONTEND=noninteractive
type unzip > /dev/null || sudo apt install unzip

mkdir -p /tmp/Unbox
cd /tmp/Unbox
pwd | grep 'Unbox-main' > /dev/null || (
touch '/tmp/unbox.lock' && wget https://github.com/keystroke3/unbox/archive/refs/heads/main.zip -O /tmp/unbox.zip && unzip /tmp/unbox.zip && cd /tmp/Unbox/Unbox-main)

## Install Eza 

sudo mkdir -p /etc/apt/keyrings

if [ ! -f /etc/apt/keyrings/gierens.gpg]; then
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list

sudo apt update && sudo apt upgrade
fi


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
	sudo apt install -y $pkg
done
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
echo "Enter new hostname or leave blank to keep $(cat /etc/hostname): "
read newhost
if [ ! -z $newhost ]
then
	sudo echo $newhost > /etc/hostname
fi

[ -f '/tmp/unzip.lock' ] && cd - && rm -r Unbox-main && rm '/tmp/unbox.lock'
