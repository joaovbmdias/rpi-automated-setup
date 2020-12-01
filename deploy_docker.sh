#!/bin/bash
source config.cfg

# deploy docker
curl -sSL https://get.docker.com | sh

sudo usermod -aG docker "$default_user"
sudo usermod -aG docker "$new_user"

# deploy docker compose
sudo apt-get install libffi-dev libssl-dev
sudo apt install python3-dev
sudo apt-get install -y python3 python3-pip
sudo pip3 install docker-compose