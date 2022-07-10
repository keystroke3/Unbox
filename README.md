# Generic Ubuntu Server Setup

---

This is a simple set up script used to quickly set up a new ubuntu server with my configs. It automatically installs my most used software and services,
nice to haves and renames the server to something more meaningful. It currently only supports Ubuntu 20.04 and higher.

### Running the script
You first need to establish a connection with the server and make sure `git` is installed. You also need a non-root user with sudo privileges. The script
does not work with root user.

Once the repo is on the server, and a non root user has been created, the script can be run.  Do so by running  

```bash
sudo ./setup.sh
```

If that results in an error then run  

```bash
sudo bash setup.sh
```

