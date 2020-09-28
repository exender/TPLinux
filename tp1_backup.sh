#!/bin/bash

# date du jour
backupdate=$(date +%Y-%m-%d)

#répertoire de backup
dirbackup=/srv/site1-$backupdate
dirbackup=/srv/site2-$backupdate
# création du répertoire de backup
/bin/mkdir $dirbackup




# tar -cjf /destination/fichier.tar.bz2 /source1 /source2 /sourceN
# sauvegarde de /home
/bin/tar -cjf  gzip $dirbackup/home/backup/site1-$backupdate.tar/srv/site1
/bin/tar -cjf  gzip $dirbackup/home/backup/site2-$backupdate.tar /srv/site2

export nombreSave=`ls -l | grep -c /home/backup/site1- /home/backup/site2-`
if [[ $nombreSave < 7 ]]
then
find . -mmin +60 -exec rm -f {} \;
fi