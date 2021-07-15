# Resumen
El actual repositorio contiene todo lo necesario para poder desplegar en Azure una arquitectura de 3 VMs (2 workers y 1 master). Este despliegue se realiza mediante IaC, usando Terraform para la creacion de la infraestructura y Ansible para la configuracion de las propias maquinas.

---
# 00 Configuracion

## Instalacion
Para la instalacion se usara CentOs8, pero es posible instaarlo en otras distribuciones como Ubuntu/Debian.

### Azure
Importamos el repositorio de Microsoft e instalamos az-cli

```
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/azure-cli.repo
sudo dnf install azure-cli
```

### Terraform
Para instalar Terraform deberemos de ejecutar los siguientes comandos.

```sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
```
Mas informacion: https://www.terraform.io/docs/cli/install/yum.html

### Ansible
Para instalar Ansible deberemos de ejecutar los siguientes comandos.

```sudo dnf install -y ansible
```
Mas informacion:https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

## Preparacion del entorno
Iniciamos sesion y seteamos el subscrition_id que hemos obtenido del portal de Azure. Luego crearemos el rol de Contributor.

```az login
az account set --subscription=<SUBSCRIPTION_ID_AQUI>
az ad sp create-for-rbac --role="Contributor" > data_azure.info
```

**IMPORTANTE 1:** Debemos de guardar la salida de este ultimo comando, lo necesitaremos para configurar el fichero `terraform/credentials.tf`. Se puede utilizar el fichero `terraform/credentials-dummy.tf` como ejemplo.

```provider "azurerm" {
  features {}
  subscription_id = "<SUBSCRIPCION ID>" # Suscripcion
  client_id       = "<APP_ID>" # Service principal "name"
  client_secret   = "<PASSWORD>" # Service principal "password"
  tenant_id       = "<TENANT>" # Service principal "tenant"
}
```

Descargar las imagenes de centos-8-stream-free para poder utilizarlas posteriormente.
```az vm image terms acept --urn cognosys:centos-8-stream-free:centos-8-stream-free:1.2019.0810
az vm image terms show --urn cognosys:centos-8-stream-free:centos-8-stream-free:1.2019.0810
```

**IMPORTANTE 2:** El valor de la variable `ssh_user` del fichero `terraform/correcion-vars.tf` tiene que ser el mismo que el valor de la variable `ADMIN_SSH` en el fichero `ansible/pre-deploy.sh`, por defecto es adminUsername.

**IMPORTANTE 3:** Debemos de crear el par clave publica/privada de SSH sin passphrase con el comando ```ssh-keygen```


## 01 Desplegar y destruir Terraform

Para poder desplegar terraform correctamente ejecutamos los siguientes comandos.
```cd terraform
# Inicia la configuracion
terraform init
# Comprobar la infraestructura
terraform plan
# Aplica la infraestructura
terraform apply
```
Informacion de los comandos aqui: https://www.terraform.io/docs/cli/commands/
Tambien se puede ejecutar esta secuencia de comandos mediante el script `bash terraform/build.sh`

Para poder destruir la infraestructura creada ejecutamos los siguientes comandos.
```cd terraform
# Inicia la configuracion
terraform init
# Destruye la infraestructura
terraform destroy
```
Tambien se puede ejecutar esta secuencia de comandos mediante el script `bash terraform/destroy.sh`

Informacion de los comandos aqui: https://www.terraform.io/docs/cli/commands/

## 02 Desplegar Ansible
Antes de desplegar los playbooks de Ansible se debera de ejecutar el fichero `bash ansible/pre-deploy.sh`.
Este script obtendra las IPs publicas y privadas de las vm desplegadas previamente en azure

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
Creamos y exportamos la carpeta "data" a los hosts indicados.

```systemctl enable nfs-server
systemctl start nfs-server
mkdir /data
echo "/data 192.168.100.110(rw,sync,no_root_squash)" >> /etc/exports
echo "/data 192.168.100.111(rw,sync,no_root_squash)" >> /etc/exports
exportfs -arv
```

Abrimos el firewall para que puedan acceder desde las otras maquinas.
```systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --add-service={nfs,mountd,rpc-bind}
firewall-cmd --reload
```

## 02 Configuracion en master y workers

TO-DO