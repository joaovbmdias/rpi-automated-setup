#!/bin/bash
source config.cfg

# deploy fail2ban
apt-get install -y fail2ban

# configure
sed -i "s/bantime = 10m/bantime = -1/" /etc/fail2ban/jail.conf
sed -i "s/maxretry = 5/maxretry = 3/" /etc/fail2ban/jail.conf