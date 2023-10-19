# Generic Ubuntu Server Setup

---

This is a simple set up script used to quickly set up a new ubuntu server with my configs. It automatically installs my most used software and services,
nice to haves and renames the server to something more meaningful. I have only tested it on Ubuntu 20.04 LTS and higher, but it should work with any other distro that uses the apt package manager.

### Usage
The script requires a user with sudo priviledges and the `wget` utility, so make sure those are setup first.
To execute the file, simply run the following:

```bash
sudo bash -c $(curl -fsSL https://raw.githubusercontent.com/keystroke3/Unbox/main/setup.sh)
```
You can also download the zip file, unzip it and manually run `./setup.sh`:

```bash
wget https://github.com/keystroke3/unbox/archive/refs/heads/main.zip -O /tmp/unbox.zip 
unzip /tmp/unbox.zip
cd Unbox-main
sudo ./setup.sh
```

If that results in an error then run  

```bash
sudo bash setup.sh
```
If you find this script useful, then star it! If you find a bug, you can create an issue and if you want fix or address a bug, you can do so by making a pull request.

