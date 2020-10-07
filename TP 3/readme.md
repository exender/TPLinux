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
