#!/bin/bash
source config.cfg

# deploy docker
curl -sSL https://get.docker.com | sh

usermod -aG docker "$default_user"
usermod -aG docker "$new_user"

# deploy docker compose
apt-get install -y libffi-dev libssl-dev
apt-get install -y python3-dev
apt-get install -y python3 python3-pip
pip3 install docker-compose