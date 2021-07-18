#!/bin/bash
cd ./ansible/

sleep 2
ansible-playbook -i hosts 00-prerequisites-on-all.yaml

sleep 30
ansible-playbook -i hosts 01-install-nfs-server-on-master.yaml

sleep 30
ansible-playbook -i hosts 02-install-nfs-client-on-workers.yaml

sleep 30
ansible-playbook -i hosts 03-install-docker-k8s-on-all.yaml

sleep 30
ansible-playbook -i hosts 04-configure-k8s-calico-sdn-haproxy-on-master.yaml

sleep 30
ansible-playbook -i hosts 05-configure-k8s-on-workers.yaml

sleep 30
ansible-playbook -i hosts 06-deploy-app-on-master.yaml
