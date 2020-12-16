#!/bin/bash
source config.cfg

# update OS with latest patches
apt-get update -y && apt-get upgrade -y

# set static IP 
grep -qxF "interface $interface" /etc/dhcpcd.conf || echo "interface $interface" >> /etc/dhcpcd.conf
grep -qxF "static ip_address=$static_ip/24" /etc/dhcpcd.conf || echo "static ip_address=$static_ip/24" >> /etc/dhcpcd.conf
grep -qxF "static routers=$router_ip" /etc/dhcpcd.conf || echo "static routers=$router_ip" >> /etc/dhcpcd.conf
grep -qxF "static domain_name_servers=$dns_server" /etc/dhcpcd.conf || echo "static domain_name_servers=$dns_server" >> /etc/dhcpcd.conf

# change hostname
sed -i "s/raspberrypi/$new_hostname/" /etc/hosts
sed -i "s/raspberrypi/$new_hostname/" /etc/hostname

# create new user
adduser "$new_user"
usermod -a -G adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input,netdev,gpio,i2c,spi "$new_user"

# restrict ssh to new user
apt-get install openssh-server
grep -qxF "AllowUsers $new_user" /etc/ssh/sshd_config || echo "AllowUsers $new_user" >> /etc/ssh/sshd_config
grep -qxF "DenyUsers $default_user" /etc/ssh/sshd_config || echo "DenyUsers $default_user" >> /etc/ssh/sshd_config
systemctl restart ssh

# change default user password
passwd

# mount network drive
mkdir -p /mnt/videos
mkdir -p /mnt/music
mkdir -p /mnt/pictures

grep -qxF "username=$nas_user" .smbcredentials || echo "user=$nas_user" >> .smbcredentials
grep -qxF "password=<$nas_password>" .smbcredentials || echo "password=<$nas_password>" >> .smbcredentials

chown $new_user:$new_user .smbcredentials
chmod 600 .smbcredentials

grep -v "\b$nas_ip\b" /etc/fstab > output && mv output /etc/fstab

echo "//$nas_ip/Public/Shared\040Videos  /mnt/videos  cifs  uid=$new_user,credentials=/home/$new_user/.smbcredentials,iocharset=utf8 0 0" >> /etc/fstab
echo "//$nas_ip/Public/Shared\040Music  /mnt/music  cifs  uid=$new_user,credentials=/home/$new_user/.smbcredentials,iocharset=utf8 0 0" >> /etc/fstab
echo "//$nas_ip/Public/Shared\040Pictures  /mnt/pictures  cifs  uid=$new_user,credentials=/home/$new_user/.smbcredentials,iocharset=utf8 0 0" >> /etc/fstab

# disable login without keypair
# #ChallengeResponseAuthentication no
# #PasswordAuthentication no
# #UsePAM no

# forcing password at every sudo command
sed -i 's/NOPASSWD/PASSWD/' /etc/sudoers.d/010_pi-nopasswd

//192.168.1.251/Public/Shared\040Music  /home/joaovbmdias/storage/music  cifs  uid=joaovbmdias,credentials=/home/joaovbmdias/.smbcredentials,iocharset=utf8 0 0
//192.168.1.251/Public/Shared\040Music  /mnt/music  cifs  uid=joaovbmdias,credentials=/home/joaovbmdias/.smbcredentials,iocharset=utf8 0 0
