# Guia instalar K8S
## 00 Prerequisitos
Comando basicos de configuracion en cada maquina. En nuestro caso solo se usara un master y un worker, el master tambien hara de servidor NFS.

```sudo dnf update -y &&
sudo timedatectl set-timezone Europe/Madrid &&
sudo dnf install chrony -y &&
sudo systemctl enable chronyd &&
sudo systemctl start chronyd &&
sudo timedatectl set-ntp true &&
sudo sed -i s/=enforcing/=disabled/g /etc/selinux/config &&
sudo dnf install nfs-utils nfs4-acl-tools -y
```

## 01 Instalar NFS
Creamos y exportamos la carpeta "data"

```systemctl enable nfs-server
systemctl start nfs-server
mkdir /data
echo "/data 192.168.100.110(rw,sync,no_root_squash)" >> /etc/exports
echo "/data 192.168.100.111(rw,sync,no_root_squash)" >> /etc/exports
exportfs -arv
```

Abrimos el firewall para que puedan acceder desde las otras maquinas
```systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --add-service={nfs,mountd,rpc-bind}
firewall-cmd --reload
```

## 02 Configuracion en master y workers



# Terraform

## Instalacion
Para instalar Terraform deberemos de ejecutar los siguientes comandos

```sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/$release/hashicorp.repo
```
Mas informacion: https://www.terraform.io/docs/cli/install/yum.html

## Preparacion
Descargar las imagenes de centos-8-stream-free
```az vm image accept-terms --urn cognosys:centos-8-stream-free:centos-8-stream-free:1.2019.0810
az vm image terms show --urn cognosys:centos-8-stream-free:centos-8-stream-free:1.2019.0810
```

**IMPORTANTE:** Editar el fichero credentials.tf con los datos necesarios

```provider "azurerm" {
  features {}
  subscription_id = "<SUBSCRIPCION ID>" # Suscripcion de portal.azure.com
  client_id       = "<APP_ID>" # Service principal "name"
  client_secret   = "<PASSWORD>" # Service principal "secret"
  tenant_id       = "<TENANT>" # Service principal "tenant"
}
```


## Desplegar

Para poder desplegar terraform correctamente ejecutamos los siguientes comandos
```cd terraform
# Inicia la configuracion
terraform init
# Comprobar la infraestructura
terraform plan
# Aplica la infraestructura
terraform apply
```