# Unbox server setup script

---

Unbox is a simple set up script used to quickly set up a new ubuntu server with my configs. It automatically installs my most used software and services,
nice to haves and renames the server to something more meaningful. I have only tested it on Ubuntu 20.04 LTS and higher, but it should work with any other distro that uses the apt package manager.

## What does it do?
The script will:
 - Install and setup zsh
 - Add my custom zshrc, aliases and minimal nvim configs
 - Add [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/) and [zsh-autosuggestions](https://github.com/zsh-users/zsh-syntax-highlighting/archive/refs/heads/master.zip)
 - Install [eza](https://eza.rocks) (an 'ls' replacement)
 - Change hostname to the given value. (A server restart is required for the changes to take effect)
 - Install the following packages by default:
    - ripgrep (required)
    - fd-find (required)
    - fzf (required)
    - eza (required)
    - zsh
    - nginx
    - certbot
    - python3-certbot-nginx
    - postgresql
    - python3-virtualenv
    - sqlite3
    - webp
    - redis
    - net-tools
    - python3-pip
    - libpangocairo-1.0-0
    - htop
    - man
    - neovim  


## Usage

The script requires a user with sudo priviledges and the `wget` utility, so make sure those are setup first.

### One liner
If you want to use the script as is by default, run:
```bash
sudo bash -c $(curl -fsSL https://raw.githubusercontent.com/keystroke3/Unbox/main/setup.sh)
```

### With modified packages
You can add or remove the packages by modifying the `packages` array in `setup.sh` before running it.  
To do so, download the script like so:
```bash
curl -fsSL https://raw.githubusercontent.com/keystroke3/Unbox/main/setup.sh > setup.sh
```
Make modifications that you want but make sure you keep the packages marked with 'required' as listed above. if you don't want to keep these packages, then you should delete the `.aliases` file.

```bash
sudo bash setup.sh
```
If you find this script useful, then star it! If you find a bug, you can create an issue and if you want fix or address a bug, you can do so by making a pull request.

