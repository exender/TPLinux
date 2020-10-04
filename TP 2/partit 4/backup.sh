#! / bin / bash

# BONNIN BAPTISTE
# 03/10/2020
# Script de sauvegarde

backup_time = " $ ( date +% Y% m% d_% H% M ) "

saved_folder_path = " $ {1} "

saved_folder = " $ {saved_folder_path ## * / } "

backup_name = " $ {saved_folder} _ $ {backup_time} "

backup_dir = " / opt / backup "

backup_path = " $ {rép_sauvegarde} / $ {dossier_enregistré} / $ {nom_sauvegarde} .tar.gz "

backup_useruid = " 1003 "
max_backup_number = 7

# On vérifie que l'utilisateur exécute le script est bien backup
if [[ $ UID  -ne  $ {backup_useruid} ]]
puis
    echo  " Ce script doit être éxecuté avec l'utilisateur backup "  > & 2
    sortie 1
Fi

# On vérifie que le dossier qu'on doit backup existe
si [[ !  -d  " $ {chemin_dossier_enregistré} " ]]
puis
    echo  " Ce dossier n'existe pas! "  > & 2
    sortie 1
Fi

# Fonction qui crée la sauvegarde
dossier_sauvegarde ()
{
    si [[ !  -d  " $ {rép_sauvegarde} / $ {chemin_dossier_sauvegardé} " ]]
    puis
        mkdir " $ {backup_dir} / $ {saved_folder_path} "
    Fi
    
    tar -czvf \
    $ {backup_path} \
    $ {rép_cible} \
    1> / dev / null \
    2> / dev / null
    
    si [[ $ ( echo $? )  -ne 0]]
    puis
        echo  " Une erreur est survenue lors de la compréssion "  > & 2
        sortie 1
    autre
        echo  " La compréssion à succès dans $ {backup_dir} / $ {saved_folder_path} "  > & 1
    Fi
}

# Fonction qui supprime la sauvegarde la plus vielle si sur une sauvegarde plus de 7
delete_outdated_backup ()
{
    if [[ $ ( ls " $ {rép_sauvegarde} / $ {chemin_dossier_enregistré} "  | wc -l )  -gt numéro_backup_max]]
    puis
        ancien_fichier = $ ( ls -t " $ {rép_sauvegarde} / $ {chemin_dossier_sauvegardé} "  | queue -1 )
        rm -rf " $ {rép_sauvegarde} / $ {chemin_dossier_sauvegardé} / $ {fichier_est_ancien} "
    Fi
}

dossier_sauvegarde
delete_outdated_backup