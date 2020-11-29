#!/bin/bash
source config.cfg

# deploy ufw
apt-get install ufw
ufw enable
ufw limit ssh

# sudo ufw allow in from 192.168.1.100 proto tcp to any port 80 comment 'HTTP'