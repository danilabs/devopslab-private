#!/bin/bash
cd ./ansible/

#sleep 1
#ansible-playbook -i hosts 00-prerequisites-on-all.yaml

#sleep 10
#ansible-playbook -i hosts 01-install-nfs-on-master.yaml

#sleep 10
#ansible-playbook -i hosts 02-mount-nfs-on-workers.yaml

#sleep 10
#ansible-playbook -i hosts 03-install-docker-k8s-on-all.yaml

sleep 10
ansible-playbook -i hosts 04-configure-k8s-on-master.yaml

sleep 10
ansible-playbook -i hosts 05-install-calico-sdn-on-master.yaml

sleep 10
ansible-playbook -i hosts 06-configure-k8s-on-workers.yaml

sleep 10
ansible-playbook -i hosts 07-install-ingress-controller-on-master.yaml

sleep 10
ansible-playbook -i hosts 08-deploy-app-on-master.yaml