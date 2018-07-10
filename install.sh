#!/bin/bash 
# Code by Green-m

# check if root
[[ $EUID != 0 ]] && echo -e "Please run this script as root." && exit 1

# check linux version
if [[ -f /etc/redhat-release ]]; then
    release="centos"
elif cat /etc/issue | grep -q -E -i "debian"; then
    release="debian"
elif cat /etc/issue | grep -q -E -i "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -q -E -i "debian"; then
    release="debian"
elif cat /proc/version | grep -q -E -i "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
    release="centos"
fi

if [[ $release == 'debian'|| 'ubuntu' ]]; then
    apt-get update
    type wget || apt-get install -y wget
    mkdir /etc/sshnotify/
    wget -q https://raw.githubusercontent.com/Green-m/sshnotify/master/sshnotify -O /etc/init.d/sshnotify
    wget -q https://raw.githubusercontent.com/Green-m/sshnotify/master/sshnotify.sh -O /usr/local/bin/sshnotify.sh
    wget -q https://raw.githubusercontent.com/Green-m/sshnotify/master/whitelist.config -O /etc/sshnotify/whitelist.config
    wget -q https://raw.githubusercontent.com/Green-m/sshnotify/master/email.config -O /etc/sshnotify/email.config
    chmod +x /usr/local/bin/sshnotify.sh
    chmod +x /etc/init.d/sshnotify
    apt-get install -y inotify-tools
    systemctl daemon-reload
    service sshnotify start && echo "sshnotify service has started."

elif [[ $release == 'centos' ]]
    yum update
    yum install -y inotify-tools
fi