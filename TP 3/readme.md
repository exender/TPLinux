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

```bash
systemctl status nginx
```

Cette unité se situe donc ici : ```/usr/lib/systemd/system/nginx.service```

## Analyse du code

```bash
[vagrant@localhost etc]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
```


ExecStart ExecStart=/usr/sbin/nginx => commande à lancer lors de systemctl start nginx

ExecStartPre