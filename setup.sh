#!/bin/bash
# Assuming running on Ubuntu/Debian
# This script should be run with sudo

sudo apt update && sudo apt upgrade
packages=("wget" "zip" "unzip" "zsh" "nginx" "certbot" "python3-certbot-nginx" "postgresql" "ripgrep" "fd-find" "fzf" "python3-virtualenv" "sqlite3" "webp" "redis")
for pkg in ${packages[@]}
do
	sudo apt install -y $pkg
done
if $(which exa &> /dev/null); then :; else
	echo "Exa not found. Installing..."
	# Install Exa
	sudo mkdir -p /usr/local/share/zsh/site-functions/
	wget https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip -O /tmp/exa.zip
	unzip /tmp/exa.zip 
	sudo mv bin/exa /usr/local/bin/
	sudo mv completions/exa.zsh /usr/local/share/zsh/site-functions/
	sudo mv man/* /usr/share/man/man1/ 
	rmdir bin completions man
fi

dots=(".aliases" ".vim" ".zshrc" ".zsh")
user_home=$(getent passwd $SUDO_USER | cut -d: -f6)
echo '***** Setting up ZSH ****'
for dot in ${dots[@]}
do
	ln -s "$(pwd)/$dot" "$user_home/$dot"
done
sudo cp -r .vim /root/
[ ! -d $user_home/.zsh ] && mkdir $user_home/.zsh
git clone https://github.com/zsh-users/zsh-autosuggestions $user_home/.zsh/zsh-autosuggestions
git clone https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git $user_home/.zsh/zsh-autoswitch-virtualenv
git clone https://github.com/zsh-users/zsh-syntax-highlighting $user_home/.zsh/zsh-syntax-highlighting
sudo sh -c "$(curl -fsSL https://starship.rs/install.sh)"
sudo usermod -s /bin/zsh $SUDO_USER
echo "Enter new hostname or leave blank to keep $HOST"
read newhost
if [ ! -z $newhost ]
then
	sudo echo $newhost > /etc/hostname
fi

echo "Set up complete. Reboot your server to apply any pending changes"



