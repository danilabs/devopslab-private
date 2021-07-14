#!/bin/bash

ansible-playbook -i hosts 00-prerequisites-on-all.yaml
ansible-playbook -i hosts 01-install-nfs-on-master.yaml
ansible-playbook -i hosts 02-mount-nfs-on-workers.yaml
ansible-playbook -i hosts 03-configuration-docker-on-all.yaml

