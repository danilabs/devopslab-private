#!/bin/bash
cd ./ansible/

sleep 2
ansible-playbook -i hosts 00-prerequisites-on-all.yaml

sleep 10
ansible-playbook -i hosts 01-install-nfs-server-on-master.yaml

sleep 2
ansible-playbook -i hosts 02-install-nfs-client-on-workers.yaml

sleep 10
ansible-playbook -i hosts 03-install-docker-k8s-on-all.yaml

sleep 2
ansible-playbook -i hosts 04-configure-k8s-on-master.yaml

sleep 2
ansible-playbook -i hosts 05-install-calico-sdn-on-master.yaml

sleep 2
ansible-playbook -i hosts 06-configure-k8s-on-workers.yaml

sleep 2
ansible-playbook -i hosts 07-install-haproxy-ingress-on-master.yaml

sleep 2
ansible-playbook -i hosts 08-deploy-app-on-master.yaml

#TODO: Revisar problema con el join-command (hacer el modulo de copy es mas facil y sencillo)
#TODO: Revisar el problema con exponer el puerto de la aplicacion