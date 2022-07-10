#!/bin/bash
sudo apt update
sudo apt install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
[ ! -f /usr/share/keyrings/docker-archive-keyring.gpg ] &&
	 curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
		 sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
[ ! -f /etc/apt/sources.list.d/docker.list ] &&
	 echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
	  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install \
	docker-ce \
	docker-ce-cli \
	containerd.io

sudo usermod $SUDO_USER -G docker
sudo systemctl start dockerd

