#!/bin/bash
cd ./ansible/
ansible-playbook -i hosts 00-prerequisites-on-all.yaml
sleep 10
ansible-playbook -i hosts 01-install-nfs-on-master.yaml
ansible-playbook -i hosts 02-mount-nfs-on-workers.yaml
sleep 10
ansible-playbook -i hosts 03-configuration-docker-on-all.yaml
sleep 10
