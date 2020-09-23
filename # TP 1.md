# TP 1 
##  Configuration de deux machines CentOS7 configurée de façon basique. 

Creation de disque SATA de 5 go avant de commencer a partitionner via LVM 

On lance notre vm puis connexion via ssh 

```bash
PS C:\Users\bapti> ssh baptiste@192.168.56.99
baptiste@192.168.56.99's password:
Last login: Wed Sep 23 14:53:20 2020
[baptiste@localhost ~]$
```
Maintenant que l'on est connecter en ssh a notre vm commençons par installer LVM 

```bash 
[baptiste@localhost ~]$ sudo yum install lvm
Modules complémentaires chargés : fastestmirror
Determining fastest mirrors
 * base: mirrors.atosworldline.com
 * extras: ftp.pasteur.fr
 * updates: ftp.pasteur.fr
base                                                                                             | 3.6 kB  00:00:00
extras                                                                                           | 2.9 kB  00:00:00
updates                                                                                          | 2.9 kB  00:00:00
(1/2): extras/7/x86_64/primary_db                                                                | 206 kB  00:00:00
(2/2): updates/7/x86_64/primary_db                                                               | 4.5 MB  00:00:09
Aucun paquet lvm disponible.
Erreur : Rien à faire
```