# TP 1 
##  Configuration de deux machines CentOS7 configurée de façon basique. 
### Prérequis

Creation de disque SATA de 5 go avant de commencer a partitionner via LVM 

On lance notre vm puis connexion via ssh pour administrer les vm's

```bash
PS C:\Users\bapti> ssh bapti@192.168.56.99
bapti@192.168.56.99's password:
Last login: Wed Sep 23 14:53:20 2020
[bapti@localhost ~]$
```

maintenant que notre disque est crée sur la vm nous partitionnons le disque en vm en ligne de commande 

```bash
[bapti@localhost ~]$ lvcreate
  No command with matching syntax recognised.  Run 'lvcreate --help' for more information.
[bapti@localhost ~]$ lvcreate -L 2000 -n volume1 data
  Logical volume "volume1" created.
[bapti@localhost ~]$ lvscan
  ACTIVE            '/dev/centos/swap' [820,00 MiB] inherit
  ACTIVE            '/dev/centos/bapti' [<6,20 GiB] inherit
  ACTIVE            '/dev/data/volume1' [1,95 GiB] inherit
[bapti@localhost ~]$ lvcreate -L 3000 -n volume3 data
  Logical volume "volume3" created.
[bapti@localhost ~]$ lvscan
  ACTIVE            '/dev/centos/swap' [820,00 MiB] inherit
  ACTIVE            '/dev/centos/bapti' [<6,20 GiB] inherit
  ACTIVE            '/dev/data/volume1' [1,95 GiB] inherit
  ACTIVE            '/dev/data/volume3' [<2,93 GiB] inherit
  ```
 maintenant nous montons les partitions dans les dossiers site 1 et site 2
```bash
 
  [bapti@localhost srv]$ mkfs -t ext4 /dev/data/Volume1
mke2fs 1.42.9 (28-Dec-2013)
Ne peut évaluer par stat() /dev/data/Volume1 --- Aucun fichier ou dossier de ce type

Le périphérique n'existe apparemment pas ; l'avez-vous spécifié
correctement ?
[bapti@localhost srv]$ mkfs -t ext4 /dev/data/volume1
mke2fs 1.42.9 (28-Dec-2013)
Étiquette de système de fichiers=
Type de système d'exploitation : Linux
Taille de bloc=4096 (log=2)
Taille de fragment=4096 (log=2)
« Stride » = 0 blocs, « Stripe width » = 0 blocs
128000 i-noeuds, 512000 blocs
25600 blocs (5.00%) réadminés pour le super utilisateur
Premier bloc de données=0
Nombre maximum de blocs du système de fichiers=524288000
16 groupes de blocs
32768 blocs par groupe, 32768 fragments par groupe
8000 i-noeuds par groupe
Superblocs de secours stockés sur les blocs :
        32768, 98304, 163840, 229376, 294912

Allocation des tables de groupe : complété
Écriture des tables d'i-noeuds : complété
Création du journal (8192 blocs) : complété
Écriture des superblocs et de l'information de comptabilité du système de
fichiers : complété

[bapti@localhost srv]$ mkfs -t ext4 /dev/data/volume2
mke2fs 1.42.9 (28-Dec-2013)
Ne peut évaluer par stat() /dev/data/volume2 --- Aucun fichier ou dossier de ce type

Le périphérique n'existe apparemment pas ; l'avez-vous spécifié
correctement ?
[bapti@localhost srv]$ mkfs -t ext4 /dev/data/Volume2
mke2fs 1.42.9 (28-Dec-2013)
Ne peut évaluer par stat() /dev/data/Volume2 --- Aucun fichier ou dossier de ce type

Le périphérique n'existe apparemment pas ; l'avez-vous spécifié
correctement ?
[bapti@localhost srv]$ mkfs -t ext4 /dev/data/volume3
mke2fs 1.42.9 (28-Dec-2013)
Étiquette de système de fichiers=
Type de système d'exploitation : Linux
Taille de bloc=4096 (log=2)
Taille de fragment=4096 (log=2)
« Stride » = 0 blocs, « Stripe width » = 0 blocs
192000 i-noeuds, 768000 blocs
38400 blocs (5.00%) réadminés pour le super utilisateur
Premier bloc de données=0
Nombre maximum de blocs du système de fichiers=786432000
24 groupes de blocs
32768 blocs par groupe, 32768 fragments par groupe
8000 i-noeuds par groupe
Superblocs de secours stockés sur les blocs :
        32768, 98304, 163840, 229376, 294912

Allocation des tables de groupe : complété
Écriture des tables d'i-noeuds : complété
Création du journal (16384 blocs) : complété
Écriture des superblocs et de l'information de comptabilité du système de
fichiers : complété

[bapti@localhost srv]$ mount /dev/data/volume1 /srv/site1
[bapti@localhost srv]$ mount /dev/data/volume3 /srv/site3
mount: le point de montage /srv/site3 n'existe pas
[bapti@localhost srv]$ mount /dev/data/volume3 /srv/site2
```

maintenant nous montons la partition dans fstab 
```bash
[bapti@localhost ~]$  14L, 626C written
[bapti@localhost ~]$ mount -av
/                         : ignoré
/boot                     : déjà monté
swap                      : ignoré
/srv/site1                : déjà monté
/srv/site2                : déjà monté
```
```bash
/dev/data/volume1           /srv/site1              ext4    defaults        0 0
/dev/data/volume3           /srv/site2              ext4    defaults        0 0
```
Changer le nom des hostnames 
```bash
vi /etc/hostname 
```
Pour check si nous avos internet nous faisons un 
```bash
nmcli dev
```
```bash
[bapti@localhost ~]$ nmcli dev
DEVICE  TYPE      STATE     CONNECTION
enp0s3  ethernet  connecté  enp0s3
enp0s8  ethernet  connecté  enp0s8
lo      loopback  non-géré  --
```
Puis nous faison un curl de google.com

```bash
[bapti@localhost ~]$ curl google.com
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
```
maintenant nous devons ping nos deux vm entre elle 

```bash 
[bapti@localhost ~]$ ping 192.168.12
PING 192.168.12 (192.168.0.12) 56(84) bytes of data.
^C
--- 192.168.12 ping statistics ---
2 packets transmitted, 0 received, 100% packet loss, time 1000ms
```

```bash 
[bapti@localhost ~]$ ping 192.168.1.11
PING 192.168.1.11 (192.168.1.11) 56(84) bytes of data.
64 bytes from 192.168.1.11: icmp_seq=1 ttl=64 time=0.516 ms
64 bytes from 192.168.1.11: icmp_seq=2 ttl=64 time=0.287 ms
64 bytes from 192.168.1.11: icmp_seq=3 ttl=64 time=0.283 ms
^C
--- 192.168.1.11 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2001ms
rtt min/avg/max/mdev = 0.283/0.362/0.516/0.108 ms
```
on peut voir que nos 2 vm's ce ping 

on doit rename nos hostname
```bash 
vi /etc/hostname
```
on remplace par node1.tp1.b2 et node2.tp1.b2
```bash 
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.1.11  node1.tp1.b2
```
```bash
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.1.12  node2.tp1.b2
```

puis reboot les 2 vm's pour effectuer le changement 

puis on peut voir via la commande ```hostname```
pour la premiere vm 
```bash
[bapti@node1 ~]$ hostname
node1.tp1.b2
```
pour la deuxieme vm 
```bash
[bapti@node2 ~]$ hostname
node2.tp1.b2
```
maintenant nous devons ping via leur noms respectif 

nous devons ajouter dans le fichier /etc/hosts

l'adresse ip et le nom de notre vm qui node2.tp1.b2

puis ca fais 

```bash
[bapti@node1 tmp]$ ping node1.tp1.b2
PING node1.tp1.b2 (10.0.2.15) 56(84) bytes of data.
64 bytes from node1.tp1.b2 (10.0.2.15): icmp_seq=1 ttl=64 time=0.010 ms
64 bytes from node1.tp1.b2 (10.0.2.15): icmp_seq=2 ttl=64 time=0.018 ms
^C
--- node1.tp1.b2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1004ms
rtt min/avg/max/mdev = 0.010/0.014/0.018/0.004 ms
[bapti@node1 tmp]$
```
et de meme via notre seconde vm's
```bash
[bapti@node2 ~]$ ping node1.tp1.b2
PING node1.tp1.b2 (192.168.1.11) 56(84) bytes of data.
64 bytes from node1.tp1.b2 (192.168.1.11): icmp_seq=1 ttl=64 time=0.356 ms
64 bytes from node1.tp1.b2 (192.168.1.11): icmp_seq=2 ttl=64 time=0.349 ms
64 bytes from node1.tp1.b2 (192.168.1.11): icmp_seq=3 ttl=64 time=0.254 ms
64 bytes from node1.tp1.b2 (192.168.1.11): icmp_seq=4 ttl=64 time=0.309 ms
64 bytes from node1.tp1.b2 (192.168.1.11): icmp_seq=5 ttl=64 time=0.293 ms
64 bytes from node1.tp1.b2 (192.168.1.11): icmp_seq=6 ttl=64 time=0.289 ms
64 bytes from node1.tp1.b2 (192.168.1.11): icmp_seq=7 ttl=64 time=0.309 ms
64 bytes from node1.tp1.b2 (192.168.1.11): icmp_seq=8 ttl=64 time=0.286 ms
^C
--- node1.tp1.b2 ping statistics ---
8 packets transmitted, 8 received, 0% packet loss, time 7006ms
rtt min/avg/max/mdev = 0.254/0.305/0.356/0.037 ms
[bapti@node2 ~]$ ping node1.tp1.b2
PING node1.tp1.b2 (192.168.1.11) 56(84) bytes of data.
64 bytes from node1.tp1.b2 (192.168.1.11): icmp_seq=1 ttl=64 time=0.252 ms
64 bytes from node1.tp1.b2 (192.168.1.11): icmp_seq=2 ttl=64 time=0.285 ms
64 bytes from node1.tp1.b2 (192.168.1.11): icmp_seq=3 ttl=64 time=0.313 ms
^C
--- node1.tp1.b2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2000ms
rtt min/avg/max/mdev = 0.252/0.283/0.313/0.028 ms
```


Creation de nouveau user avec les droit sudo 

```bash 
[bapti@node2 ~]$ useradd admin1
[bapti@node2 ~]$ sudo visudo 
```
puis edit les droit sudo en donnant les droits sudo 

```bash
## Allow bapti to run any commands anywhere
bapti    ALL=(ALL)       ALL
admin1  ALL=(ALL)       ALL
```

sur les deux vm's

## Utilisation que de ssh 
vous n'utilisez QUE ssh pour administrer les machines

création d'une paire de clés (sur VOTRE PC)
```bash
PS C:\Users\bapti\.ssh> cat .\known_hosts
192.168.1.11 ecdsa-sha2-nistp256 [...]=
192.168.1.12 ecdsa-sha2-nistp256 [...]=
```

déposer la clé sur l'utilisateur 

Machine 1
```bash
PS C:\Users\bapti> ssh admin1@192.168.1.11
admin1@192.168.1.11's password:
Last login: Thu Sep 24 14:10:21 2020 from 192.168.1.10
Last login: Thu Sep 24 14:10:21 2020 from 192.168.1.10
[admin1@node1 ~]$
```
Machine 2
```bash 
PS C:\Users\bapti> ssh admin2@192.168.1.12
admin2@192.168.1.12's password:
Last login: Thu Sep 24 15:09:52 2020 from 192.168.1.10
Last login: Thu Sep 24 15:09:52 2020 from 192.168.1.10
[admin2@node2 ~]$
```

## Firewall
le pare-feu est configuré pour bloquer toutes les connexions exceptées celles qui sont nécessaires

commande firewall-cmd ou iptables

Machine 1
```bash
[admin1@node1 ~]$ sudo firewall-cmd --list-all
Authorization failed.
  Make sure polkit agent is running or run the application as superuser.

[admin1@node1 ~]$ sudo !!
sudo firewall-cmd --list-all
public (active)
target: default
icmp-block-inversion: no
interfaces: enp0s3 enp0s8
sources:
adminices: dhcpv6-client ssh
ports:
protocols:
masquerade: no
forward-ports:
source-ports:
icmp-blocks:
rich rules:
[admin1@node1 ~]\$
```
Machine 2
```bash
[admin2@node2 ~]$ sudo firewall-cmd --list-all
[sudo] password for admin:
public (active)
target: default
icmp-block-inversion: no
interfaces: enp0s3 enp0s8
sources:
adminices: dhcpv6-client ssh
ports:
protocols:
masquerade: no
forward-ports:
source-ports:
icmp-blocks:
rich rules:
[admin2@node2 ~]\$
```


désactiver SELinux

Machine 1
```bash
[admin1@node1 ~]$ sestatus
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux bapti directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   permissive
Mode from config file:          permissive
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Max kernel policy version:      31
[admin1@node1 ~]$
```
Machine 2

```bash
[admin2@node2 ~]$ sestatus
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux bapti directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   permissive
Mode from config file:          permissive
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Max kernel policy version:      31
[admin@node2 ~]$
```


## Install de nginx sous Centos7
Les package de Nginx sont dans les depos de Epel donc nous devons d'abord ajouter les depot via :

```bash
sudo yum install epel-release
```

```bash
[admin1@node1~]$ sudo yum install epel-release
Modules complémentaires chargés : fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirrors.atosworldline.com
 * extras: ftp.pasteur.fr
 * updates: ftp.pasteur.fr
Résolution des dépendances
--> Lancement de la transaction de test
---> Le paquet epel-release.noarch 0:7-11 sera installé
--> Résolution des dépendances terminée

Dépendances résolues

========================================================================================================================
 Package                          Architecture               Version                   Dépôt                      Taille
========================================================================================================================
Installation :
 epel-release                     noarch                     7-11                      extras                      15 k

Résumé de la transaction
========================================================================================================================
Installation   1 Paquet

Taille totale des téléchargements : 15 k
Taille d'installation : 24 k
Is this ok [y/d/N]: y
Downloading packages:
epel-release-7-11.noarch.rpm                                                                     |  15 kB  00:00:00
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installation : epel-release-7-11.noarch                                                                           1/1
  Vérification : epel-release-7-11.noarch                                                                           1/1

Installé :
  epel-release.noarch 0:7-11

Terminé !
```
une fois fais ceci nous allons pouvoir installer nginx via :

```bash 
sudo yum install -y nginx
```

## Creation des fichiers d'index html

creation des fichier on doit changer de directory

```bash 
[admin1@node1 ~]$  cd /srv/site1
[admin1@node1 site1]$
[admin1@node1 site1]$ touch index.html
[admin1@node1 site1]$
```

Puis dans le dossier site 2

```bash 
[admin1@node1 site1]$ cd /srv/site2
[admin1@node1 site2]$ touch index.html
```


## Config de NGINX
Les permissions sur ces dossiers doivent être le plus restrictif possible et, ces dossiers doivent appartenir à un utilisateur et un groupe spécifique
```bash
[admin1@node1 ~]$ sudo ls -al /srv/
total 8
drwxr-xr-x.  4 root root   32 Sep 23 17:31 .
dr-xr-xr-x. 17 root root  237 Sep 22 14:21 ..
dr--------.  3 web  web  4096 Sep 24 15:39 site1
dr--------.  3 web  web  4096 Sep 24 15:39 site2
[admin1@node1 ~]

```
NGINX doit utiliser un utilisateur dédié que vous avez créé à cet effet
```bash
[admin1@node1 ~]$ sudo useradd web
```
les sites doivent être admin1is en HTTPS sur le port 443 et en HTTP sur le port 80
```bash
[admin1@node1 ~]$ sudo firewall-cmd --zone=public --add-port=443/tcp --permanent
success

[admin1@node1 ~]$ sudo firewall-cmd --permanent --zone=public --add-admin1ice=https
success

[admin1@node1 ~]$ sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
success

[admin1@node1 ~]$ sudo firewall-cmd --permanent --zone=public --add-admin1ice=http
success

[admin1@node1 ~]$ sudo firewall-cmd --reload
success
[admin1@node1 ~]$

```





## étape du scripting 

lien du script: https://github.com/exender/TPLinux/blob/master/tp1_backup.sh

