# TP 1 
##  Configuration de deux machines CentOS7 configurée de façon basique. 

Creation de disque SATA de 5 go avant de commencer a partitionner via LVM 

On lance notre vm puis connexion via ssh pour administrer les vm's

```bash
PS C:\Users\bapti> ssh baptiste@192.168.56.99
baptiste@192.168.56.99's password:
Last login: Wed Sep 23 14:53:20 2020
[baptiste@localhost ~]$
```

maintenant que notre disque est crée sur la vm nous partitionnons le disque en vm en ligne de commande 

```bash
[root@localhost ~]# lvcreate
  No command with matching syntax recognised.  Run 'lvcreate --help' for more information.
[root@localhost ~]# lvcreate -L 2000 -n volume1 data
  Logical volume "volume1" created.
[root@localhost ~]# lvscan
  ACTIVE            '/dev/centos/swap' [820,00 MiB] inherit
  ACTIVE            '/dev/centos/root' [<6,20 GiB] inherit
  ACTIVE            '/dev/data/volume1' [1,95 GiB] inherit
[root@localhost ~]# lvcreate -L 3000 -n volume3 data
  Logical volume "volume3" created.
[root@localhost ~]# lvscan
  ACTIVE            '/dev/centos/swap' [820,00 MiB] inherit
  ACTIVE            '/dev/centos/root' [<6,20 GiB] inherit
  ACTIVE            '/dev/data/volume1' [1,95 GiB] inherit
  ACTIVE            '/dev/data/volume3' [<2,93 GiB] inherit
  ```
 maintenant nous montons les partitions dans les dossiers site 1 et site 2
```bash
 
  [root@localhost srv]# mkfs -t ext4 /dev/data/Volume1
mke2fs 1.42.9 (28-Dec-2013)
Ne peut évaluer par stat() /dev/data/Volume1 --- Aucun fichier ou dossier de ce type

Le périphérique n'existe apparemment pas ; l'avez-vous spécifié
correctement ?
[root@localhost srv]# mkfs -t ext4 /dev/data/volume1
mke2fs 1.42.9 (28-Dec-2013)
Étiquette de système de fichiers=
Type de système d'exploitation : Linux
Taille de bloc=4096 (log=2)
Taille de fragment=4096 (log=2)
« Stride » = 0 blocs, « Stripe width » = 0 blocs
128000 i-noeuds, 512000 blocs
25600 blocs (5.00%) réservés pour le super utilisateur
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

[root@localhost srv]# mkfs -t ext4 /dev/data/volume2
mke2fs 1.42.9 (28-Dec-2013)
Ne peut évaluer par stat() /dev/data/volume2 --- Aucun fichier ou dossier de ce type

Le périphérique n'existe apparemment pas ; l'avez-vous spécifié
correctement ?
[root@localhost srv]# mkfs -t ext4 /dev/data/Volume2
mke2fs 1.42.9 (28-Dec-2013)
Ne peut évaluer par stat() /dev/data/Volume2 --- Aucun fichier ou dossier de ce type

Le périphérique n'existe apparemment pas ; l'avez-vous spécifié
correctement ?
[root@localhost srv]# mkfs -t ext4 /dev/data/volume3
mke2fs 1.42.9 (28-Dec-2013)
Étiquette de système de fichiers=
Type de système d'exploitation : Linux
Taille de bloc=4096 (log=2)
Taille de fragment=4096 (log=2)
« Stride » = 0 blocs, « Stripe width » = 0 blocs
192000 i-noeuds, 768000 blocs
38400 blocs (5.00%) réservés pour le super utilisateur
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

[root@localhost srv]# mount /dev/data/volume1 /srv/site1
[root@localhost srv]# mount /dev/data/volume3 /srv/site3
mount: le point de montage /srv/site3 n'existe pas
[root@localhost srv]# mount /dev/data/volume3 /srv/site2
```

maintenant nous montons la partition dans fstab 
```bash
[root@localhost ~]#  14L, 626C written
[root@localhost ~]# mount -av
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
[root@localhost ~]# nmcli dev
DEVICE  TYPE      STATE     CONNECTION
enp0s3  ethernet  connecté  enp0s3
enp0s8  ethernet  connecté  enp0s8
lo      loopback  non-géré  --
```
Puis nous faison un curl de google.com

```bash
[root@localhost ~]# curl google.com
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
```
maintenant nous devons ping nos deux vm entre elle 

```bash 
[root@localhost ~]# ping 192.168.12
PING 192.168.12 (192.168.0.12) 56(84) bytes of data.
^C
--- 192.168.12 ping statistics ---
2 packets transmitted, 0 received, 100% packet loss, time 1000ms
```

```bash 
[root@localhost ~]# ping 192.168.1.11
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

puis reboot les 2 vm's pour effectuer le changement 

puis on peut voir via la commande ```hostname```
pour la premiere vm 
```bash
[root@node1 ~]# hostname
node1.tp1.b2
```
pour la deuxieme vm 
```bash
[root@node2 ~]# hostname
node2.tp1.b2
```

Creation de nouveau user avec les droit sudo 

```bash 
[root@node2 ~]# useradd admin2
[root@node2 ~]# vi /etc/sudoers
```
sur les deux vm's

## Install de nginx sous Centos7
Les package de Nginx sont dans les depos de Epel donc nous devons d'abord ajouter les depot via :

```bash
sudo yum install epel-release
```

```bash
[root@localhost ~]# sudo yum install epel-release
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
