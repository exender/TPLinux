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