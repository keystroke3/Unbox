#!/bin/bash
# Assuming running on Ubuntu/Debian
# This script should be run with sudo by a non-root user


# Add or remove packages from this list
packages=("unzip" "zsh" "ripgrep" "fd-find" "fzf" "nginx" "python3-virtualenv"  "eza" "net-tools" "python3-pip" "libpangocairo-1.0-0" "htop" "man" "git" "tmux")

# do not modify the code below this point unless you know what you are doing


username=
user_home=
error_msg=
key_string=
install_docker=
hostname=
create_user=

no_hostname=
no_key=
no_shell=

export DEBIAN_FRONTEND=noninteractive

setup_user(){
    [ ! -z $create_user ] && $username=$create_user 
    if [ -z $username]; then
	read -p "Account username to use: " -r _user
	if [ -z $_user ];then
	    echo "username is required"
	    exit 1
	fi
	username=$_user
    fi
    user_home=$(getent passwd $username | cut -d: -f6)
    [ ! -z $user_home ];return 0
    if [ -z $create_user ]; then
	printf "User $username does not exist or is not a normal user. Create a new user? (y/N) " 
	read create_user
	if [ ! "$(echo $create_user | tr '[:upper:]' '[:lower:]')" == 'y' ]; then
	    exit 1
	fi
    fi
    echo "creating new user"
    sudo useradd -s /usr/bin/zsh -m -G sudo
    sudo passwd $username
    mkdir -p $user_home/.ssh/
    set_public_key
}

set_public_key(){
    [ ! -z $no_key ] && return
    printf "$error_msg"
    if [ ! -z "$key_string" ]; then
	echo "$ssh_public" >> $user_home/.ssh/authorized_keys
	return
    fi
    read -p "ssh public key (leave blank to skip) " -r ssh_public
    [ -z "$ssh_public" ] && return
    ssh_public=$(printf "%s" "$ssh_public")
    if ! echo "$ssh_public" | ssh-keygen -l -f /dev/stdin > /dev/null; then
	error_msg="Input is not a valid ssh key "
	set_public_key
    fi
    echo "writing ssh key"
    echo "$ssh_public" >> $user_home/.ssh/authorized_keys
}

shell_stup(){
    [ ! -z $no_shell ] && return
    pwd | grep 'Unbox-main' > /dev/null || (
    touch '/tmp/unbox.lock' && wget https://github.com/keystroke3/unbox/archive/refs/heads/main.zip -O /tmp/unbox.zip && unzip /tmp/unbox.zip -d /tmp/ && cd /tmp/Unbox-main)
    dots=(".aliases" ".vim" ".zshrc", ".tmux.conf")
    for dot in ${dots[@]}
    do
	cp -r "/tmp/Unbox-main/$dot" "$user_home/$dot"
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
    sudo usermod -s /bin/zsh $username
    sudo chown -R $username:$username $user_home
}


install_packages(){
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y ${packages[@]}
}

docker_install(){

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

}


set_hostname(){
    [ ! -z $no_hostname ] && return 
    [ ! -z $hostname ] && sudo echo $hostname > /etc/hostname && return
    echo "Enter new hostname or leave blank to keep $(cat /etc/hostname): "
    read newhost
    if [ ! -z $newhost ]
    then
	sudo echo $newhost > /etc/hostname
    fi
}

print_help(){
    echo "Setup a new server with zsh and some default settings"
    echo "Usage:
    -u|--username: the name of the account to be used (required)
    -k|--key: an ssh public key to be added to be added to the user's account
    -d|--install-docker: if docker should be installed
    -H|--hostname: sets the hostname of the server to a given value
    -h|--help: print this help message
    --no-hostname: disables setting the hostname
    --no-key: disables setting the ssh public key
    --no-shell: disables setting up the shell
    "
    exit 0
}

start(){
    while [[ $# -gt 0 ]]; do
	case "$1" in
	    -u|--username)
		username="$2"
		shift 2;;
	    -U|--create-user)
		create_user="$2"
		shift 2;;
	    -k|--key)
		key_string="$2"
		shift 2;;
	    --no-key)
		no_key="Y"
		shift 1;;
	    -d|--install-docker)
		install_docker="Y"
		shift 1;;
	    -H|--hostname)
		hostname="$2"
		shift 2;;
	    --no-hostname)
		no_hostname="Y"
		shift 1;;
	    --no-shell)
		no_shell="Y"
		shift 1;;
	    -h|--help)
		print_help
		return 0;;
	    *)
		echo "Invalid argument: $1"
		exit 1;;
	esac
    done

    echo 

    setup_user
    install_packages
    set_public_key
    setup_shell
    set_hostname
    [ ! -z $install_docker ] && docker_install
}

start "$@"
