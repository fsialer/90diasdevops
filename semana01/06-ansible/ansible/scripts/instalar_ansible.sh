#!/bin/bash
apt update && apt upgrade -y
apt install ansible -y
ansible --version
mkdir -p /etc/ansible && touch /etc/ansible/hosts
echo "[webservers]" > /etc/ansible/hosts
echo "192.168.16.10 ansible_user=vagrant ansible_ssh_private_key_file=~/.ssh/web" >> /etc/ansible/hosts

#ansible all -m service -a "name=nginx state=started"
#ansible all -m shell -a "systemctl status nginx"
