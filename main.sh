#!/bin/bash
source config.cfg

# update OS with latest patches
sudo apt-get update -y && sudo apt-get upgrade -y

# set static IP 
grep -qxF "interface $interface" /etc/dhcpcd.conf || echo "interface $interface" >> /etc/dhcpcd.conf
grep -qxF "static ip_address=$static_ip/24" /etc/dhcpcd.conf || echo "static ip_address=$static_ip/24" >> /etc/dhcpcd.conf
grep -qxF "static routers=$router_ip" /etc/dhcpcd.conf || echo "static routers=$router_ip" >> /etc/dhcpcd.conf
grep -qxF "static domain_name_servers=$dns_server" /etc/dhcpcd.conf || echo "static domain_name_servers=$dns_server" >> /etc/dhcpcd.conf

# change hostname
sudo sed -i "s/raspberrypi/$new_hostname/" /etc/hosts
sudo sed -i "s/raspberrypi/$new_hostname/" /etc/hostname

# create new user
sudo adduser "$new_user"
sudo usermod -a -G adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input,netdev,gpio,i2c,spi "$new_user"