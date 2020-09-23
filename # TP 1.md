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

maintenant que notre disque est cree sur la vm nous partitionnons le disque en vm en ligne de commande 

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
```bash
  maintenant nous montons les partitions dans les dossiers site 1 et site 2
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

