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

pls acutelle 

passons au serveur web je sens la pls

## Serveur web 

🌞

Le code du service est à retrouver dans ./systemd/units/server-wer.service


Faisons le test pour prouver tout ça



