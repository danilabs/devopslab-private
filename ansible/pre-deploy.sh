#!/bin/bash

#EDITAR
ADMIN_SSH="adminUsername"

# EDITAR SI ES NECESARIO
MASTER_HOSTNAME="master.localhostunir.local"
WORKER1_HOSTNAME="worker1.localhostunir.local"
WORKER2_HOSTNAME="worker2.localhostunir.local"
GROUP_RESOURCE="kubernetesrg"

# NO EDITAR
cd ./ansible/
# Obtenemos las IPs publicas y privadas. Hacemos una primera conexion para confirmar la firma de SSH
master_public_ip=`az vm show -d -g $GROUP_RESOURCE -n $MASTER_HOSTNAME --query "publicIps" -o tsv`
master_private_ip=`az vm show -d -g $GROUP_RESOURCE -n $MASTER_HOSTNAME --query "privateIps" -o tsv`
echo "[!] Host: $MASTER_HOSTNAME IP(Public):$master_public_ip IP (Private):$master_private_ip"
ssh -o "StrictHostKeyChecking no" $ADMIN_SSH@$master_public_ip << EOF
exit
EOF

worker1_public_ip=`az vm show -d -g $GROUP_RESOURCE -n $WORKER1_HOSTNAME --query "publicIps" -o tsv`
worker1_private_ip=`az vm show -d -g $GROUP_RESOURCE -n $WORKER1_HOSTNAME --query "privateIps" -o tsv`
echo "[!] Host: $MASTER_HOSTNAME IP(Public):$worker1_public_ip IP (Private):$worker1_private_ip"
ssh -o "StrictHostKeyChecking no" $ADMIN_SSH@$worker1_public_ip << EOF
exit
EOF

worker2_public_ip=`az vm show -d -g $GROUP_RESOURCE -n $WORKER2_HOSTNAME --query "publicIps" -o tsv`
worker2_private_ip=`az vm show -d -g $GROUP_RESOURCE -n $WORKER2_HOSTNAME --query "privateIps" -o tsv`
echo "[!] Host: $MASTER_HOSTNAME IP(Public):$worker2_public_ip IP (Private):$worker2_private_ip"
ssh -o "StrictHostKeyChecking no" $ADMIN_SSH@$worker2_public_ip << EOF
exit
EOF

# Creamos el fichero ansible/hosts en funcion de las IPs para poder conectarnos
echo "[all:vars]
ansible_user=$ADMIN_SSH
ansible_connection=ssh

private_master_ip=$master_private_ip
hostname_master=$MASTER_HOSTNAME

private_worker1_ip=$worker1_private_ip
hostname_worker1=$WORKER1_HOSTNAME

private_worker2_ip=$worker2_private_ip
hostname_worker2=$WORKER2_HOSTNAME

[master]
$master_public_ip

[workers]
$worker1_public_ip
$worker2_public_ip" > hosts