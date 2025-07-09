#!/bin/bash
apt update
apt install -y ansible
ansible-playbook  /vagrant/playbook.yml