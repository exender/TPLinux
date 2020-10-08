# TP 3
# 0 Prérequis 

🌞 Nombre de service dispos
```bash
[vagrant@localhost ~]$ systemctl list-unit-files --type=service | tail -1 | cut -d " " -f 1
155
```

🌞 Nombres de services actifs
```bash 
systemctl -t service --all | grep running | wc -l
```
🌞 Nombre de service  échoué ou inactif

```bash
[vagrant@localhost ~]$ systemctl -t service --all | grep -E 'inactive|failed' | wc -l
73

```
🌞 Nombre de service activée

```bash
systemctl list-unit-files --type=service | grep enabled | wc -l
32
```
![alt text](https://github.com/exender/TPLinux/blob/master/pics/the-end.gif)

(que pour cette partit)

## 2 Analyser un service

🌞
```bash
[vagrant@localhost etc]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
```


Cette unité se situe donc ici : /usr/lib/systemd/system/nginx.service

## Analyse du code
```bas
[vagrant@localhost etc]$ systemctl cat nginx
# /usr/lib/systemd/system/nginx.service
[Unit]
Description=The nginx HTTP and reverse proxy server
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
# Nginx will fail to start if /run/nginx.pid already exists but has the wrong
# SELinux context. This might happen when running `nginx -t` from the cmdline.
# https://bugzilla.redhat.com/show_bug.cgi?id=1268621
ExecStartPre=/usr/bin/rm -f /run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/bin/kill -s HUP $MAINPID
KillSignal=SIGQUIT
TimeoutStopSec=5
KillMode=process
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```


ExecStartPre
```bash
ExecStartPre=/usr/bin/rm -f /run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t

```
puis on verifie le pid nginx  
```bash
[vagrant@localhost etc]$ cat /run/nginx.pid
11980
```
 => chemin absolu vers le fichier contenant le PID, actuellement, nginx à le PID 11980

Type ````Type=forking``` => cela signifie que ce processus va créer d'autres processus enfant par duplication via la fonction fork()

ExecReload ```ExecReload=/bin/kill -s HUP $MAINPID``` => commande à lancer lors de systemctl reload nginx

Description Description=The nginx HTTP and reverse proxy server => courte description du service

After ```After=network.target remote-fs.target nss-lookup.target``` => vérifie que les services dont dépendent nginx ont fini d'être exéctuté

## Liste utilisant WantedBy=multi-user.target:
🌞
```bash
/usr/lib/systemd/system/auditd.service:WantedBy=multi-user.target
/usr/lib/systemd/system/brandbot.path:WantedBy=multi-user.target
/usr/lib/systemd/system/chronyd.service:WantedBy=multi-user.target
/usr/lib/systemd/system/chrony-wait.service:WantedBy=multi-user.target
/usr/lib/systemd/system/cpupower.service:WantedBy=multi-user.target
/usr/lib/systemd/system/crond.service:WantedBy=multi-user.target
/usr/lib/systemd/system/ebtables.service:WantedBy=multi-user.target
/usr/lib/systemd/system/firewalld.service:WantedBy=multi-user.target
/usr/lib/systemd/system/fstrim.timer:WantedBy=multi-user.target
/usr/lib/systemd/system/gssproxy.service:WantedBy=multi-user.target
/usr/lib/systemd/system/irqbalance.service:WantedBy=multi-user.target
/usr/lib/systemd/system/machines.target:WantedBy=multi-user.target
/usr/lib/systemd/system/NetworkManager.service:WantedBy=multi-user.target
/usr/lib/systemd/system/nfs-client.target:WantedBy=multi-user.target
/usr/lib/systemd/system/nfs-rquotad.service:WantedBy=multi-user.target
/usr/lib/systemd/system/nfs-server.service:WantedBy=multi-user.target
/usr/lib/systemd/system/nfs.service:WantedBy=multi-user.target
/usr/lib/systemd/system/nginx.service:WantedBy=multi-user.target
/usr/lib/systemd/system/postfix.service:WantedBy=multi-user.target
/usr/lib/systemd/system/rdisc.service:WantedBy=multi-user.target
/usr/lib/systemd/system/remote-cryptsetup.target:WantedBy=multi-user.target
/usr/lib/systemd/system/remote-fs.target:WantedBy=multi-user.target
/usr/lib/systemd/system/rhel-configure.service:WantedBy=multi-user.target
/usr/lib/systemd/system/rpcbind.service:WantedBy=multi-user.target
/usr/lib/systemd/system/rpc-rquotad.service:WantedBy=multi-user.target
/usr/lib/systemd/system/rsyncd.service:WantedBy=multi-user.target
/usr/lib/systemd/system/rsyslog.service:WantedBy=multi-user.target
/usr/lib/systemd/system/sshd.service:WantedBy=multi-user.target
/usr/lib/systemd/system/tcsd.service:WantedBy=multi-user.target
/usr/lib/systemd/system/tuned.service:WantedBy=multi-user.target
/usr/lib/systemd/system/vmtoolsd.service:WantedBy=multi-user.target
/usr/lib/systemd/system/wpa_supplicant.service:WantedBy=multi-user.target
```


## Création d'un service


![alt text](https://github.com/exender/TPLinux/blob/master/pics/the-end.gif)

les services ce trouvent dans /etc/systemd/system

ont crée un fichier .service 

vim serveurweb.service

```bash 

Description=web server for leo's tp

[Service]
Type=simple
user=nginx
Environment="PORT=8080"
ExecStartPre=+/usr/bin/firewalld --add-port=${PORT}/tcp
ExecStart=/usr/bin/python2 -m SimpleHTTPServer ${PORT}
PIDFile=/etc/systemd/system/index.html
ExecStop=+/usr/bin/firewalld --remove-port=${PORT}/tcp

[Install]
WantedBy=multi-user.target
```

```bash 
sudo systemctl status WebServer.service
● WebServer.service - server web pour le tp3
   Loaded: loaded (/etc/systemd/system/WebServer.service; disabled; vendor preset: disabled)
   Active: active (running) since Wed 2020-10-07 14:16:03 UTC; 4min 21s ago
 Main PID: 4208 (sudo)
   CGroup: /system.slice/WebServer.service
           ‣ 4208 /usr/bin/sudo /usr/bin/python3 -m http.server 1025

Oct 07 14:16:02 tp3.b2 systemd[1]: Starting server web pour le tp3...
Oct 07 14:16:02 tp3.b2 sudo[4201]:      web : TTY=unknown ; PWD=/ ; USER=root ; COMMAND=/usr/bin/firewall-cmd --add...25/tcp
Oct 07 14:16:03 tp3.b2 systemd[1]: Started server web pour le tp3.
Oct 07 14:16:03 tp3.b2 sudo[4208]:      web : TTY=unknown ; PWD=/ ; USER=root ; COMMAND=/usr/bin/python3 -m http.server 1025
Hint: Some lines were ellipsized, use -l to show in full.
```

```bash 
[vagrant@tp3 system]$ sudo systemctl enable WebServer.service
Created symlink from /etc/systemd/system/multi-user.target.wants/WebServer.service to /etc/systemd/system/WebServer.service.
[vagrant@tp3 system]$
```
```bash
[vagrant@tp3 system]$ curl localhost:1025
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Directory listing for /</title>
</head>
<body>
<h1>Directory listing for /</h1>
<hr>
<ul>
<li><a href="bin/">bin@</a></li>
<li><a href="boot/">boot/</a></li>
<li><a href="dev/">dev/</a></li>
<li><a href="etc/">etc/</a></li>
<li><a href="home/">home/</a></li>
<li><a href="lib/">lib@</a></li>
<li><a href="lib64/">lib64@</a></li>
<li><a href="media/">media/</a></li>
<li><a href="mnt/">mnt/</a></li>
<li><a href="opt/">opt/</a></li>
<li><a href="proc/">proc/</a></li>
<li><a href="root/">root/</a></li>
<li><a href="run/">run/</a></li>
<li><a href="sbin/">sbin@</a></li>
<li><a href="srv/">srv/</a></li>
<li><a href="swapfile">swapfile</a></li>
<li><a href="sys/">sys/</a></li>
<li><a href="tmp/">tmp/</a></li>
<li><a href="usr/">usr/</a></li>
<li><a href="var/">var/</a></li>
</ul>
<hr>
</body>
</html>
[vagrant@tp3 system]$
```

pls acutelle 
![alt text](https://github.com/exender/TPLinux/blob/master/pics/the-end.gif)
tjr en pls apres ca 

## sauvegarde 

🌞

Créez une unité de service qui déclenche une sauvegarde avec votre script
On créer un user sudo useradd backup. On lui met un mot de passe sudo passwd backup.

On fait la commande : sudo usermod -aG wheel backup

On configure notre unité de service :
```bash
[vagrant@localhost ~]$ sudo vim /etc/systemd/system/backup.service
```
(La config se trouve sur le git dans systemd/units/)

On reload : sudo systemctl daemon-reload

On rempli l'index.html pour la forme.
```bash 
[vagrant@localhost ~]$ sudo vim /srv/site1/index.html

[vagrant@localhost ~]$ cat /srv/site1/index.html
Index site1
[vagrant@localhost ~]$ sudo vim pre_backup.sh
[vagrant@localhost ~]$ sudo vim backup.sh
[vagrant@localhost ~]$ sudo vim after_backup.sh
```
(Le contenu des scripts se trouve sur le git dans scripts_tp/)

Ecrire un fichier .timer systemd
Lance la backup toutes les heures :

On configure notre timer :
```bash
[vagrant@localhost ~]$ sudo vim /usr/lib/systemd/system/backup.timer
```
(Sa config se trouve sur le git dans systemd/units/)

On démarre le timer et on lui dit de démarrer lorsque la machine démarre.
```bash
[vagrant@localhost ~]$ sudo systemctl start backup.timer
[vagrant@localhost ~]$ sudo systemctl enable backup.timer
```
On liste les timers pour vérifier qu'il est bien ajouté :
```bash
[vagrant@localhost ~]$ systemctl list-timers
NEXT                         LEFT     LAST                         PASSED       UNIT                         ACTIVATE
Wed 2020-10-07 11:00:00 UTC  45s left n/a                          n/a          backup.timer                 backup.s
Thu 2020-10-08 08:45:14 UTC  21h left Wed 2020-10-07 08:45:14 UTC  2h 13min ago systemd-tmpfiles-clean.timer systemd-
```
2 timers listed.
Notre backup.timer est bien mis en place.





## II. Autres fonctionnalités 

🌞
## Gestion de boot 


On fait ```bash systemd-analyze plot > oue.svg ``` pour récupérer les infos de la commande, puis on l'analyse.

Après analyse du fichier plot.svg, les 3 services les plus lents à démarrer sont :
```bash
web.service
firewalld.service
swapfile.swap
```
## Gestion de l'heure 
```bash 
[vagrant@localhost system]$ timedatectl
      Local time: Wed 2020-10-07 14:44:25 UTC
  Universal time: Wed 2020-10-07 14:44:25 UTC
        RTC time: Wed 2020-10-07 14:44:24
       Time zone: UTC (UTC, +0000)
     NTP enabled: yes
NTP synchronized: yes
 RTC in local TZ: no
      DST active: n/a

```

donc on peut voir que l'on est synchroniser sur un serveur NTP

et on est sur le fuseau horraire 
  Time zone: UTC (UTC, +0000)

Maintenant on va changer de fuseau 

  on va lister tout les Fuseaux horraire disponible 
```bash
  timedatectl list-timezones
```
  puis set le fuseaux horraire de son choix perso Africa/Lagos
```bash
  timedatectl set-timezone Africa/Lagos
```
  puis on verifie 

```bash 
  [vagrant@localhost ~]$ timedatectl
      Local time: Wed 2020-10-07 16:05:01 WAT
  Universal time: Wed 2020-10-07 15:05:01 UTC
        RTC time: Wed 2020-10-07 15:05:00
       Time zone: Africa/Lagos (WAT, +0100)
     NTP enabled: yes
NTP synchronized: yes
 RTC in local TZ: no
      DST active: n/a
```
voila on peut observer que les changements ont bien été effectuer 

## Gestion des noms et de la résolution de noms

🌞

```bash
 hostnamectl
   Static hostname: localhost.localdomain
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 4cc14141794f474fa9cbe0f6488b5f09
           Boot ID: d543fe9be2964b6293f61d14a2bc7b2a
    Virtualization: kvm
  Operating System: CentOS Linux 7 (Core)
       CPE OS Name: cpe:/o:centos:centos:7
            Kernel: Linux 3.10.0-1127.el7.x86_64
      Architecture: x86-64
```

Mon nom d'hote actuelle est  localhost.localdomain

je vais changer le nom d'hote via la commande 

```bash 
sudo hostnamectl set-hostname ouaiouailetp
```

je vais remplacer par ouaiouailetp

apres avoir sauvegarder le nom reboot la machine 

puis faire un 

```bash 
hostnamectl ou hostname 
```

puis on obtien ca

```bash 

[vagrant@ouaiouailetp ~]$ hostnamectl
   Static hostname: ouaiouailetp
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 4cc14141794f474fa9cbe0f6488b5f09
           Boot ID: 09710157dbc14faaaa1dfcb869295c69
    Virtualization: kvm
  Operating System: CentOS Linux 7 (Core)
       CPE OS Name: cpe:/o:centos:centos:7
            Kernel: Linux 3.10.0-1127.el7.x86_64
      Architecture: x86-64
```


![alt text](https://github.com/exender/TPLinux/blob/master/pics/the-end.gif)

fin du tp eazi (c fo)