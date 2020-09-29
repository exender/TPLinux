# TP 2 Linux Vagrant

## Deploiment simple

lien de la partit 1:

## Re-package

```bash 
sudo yum install epel-release
```
```bash
sudo yum install -y nginx
```
## Re-package une box 

```bash
vagrant package --output centos7-tp2-b2.box
```
```bash
vagrant box add centos7-custom centos7-custom.box
```

## Ajout du disque de 5GO
on va add dans notre vagrant file 
lien de du 
config.vm.disk :disk, name: "backup", size: "5GB"


## partit 3