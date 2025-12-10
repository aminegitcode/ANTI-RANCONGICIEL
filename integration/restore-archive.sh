#!/bin/bash


fichier_archives="./sh-toolbox/archives"
tmp_dossier=".sh-toolbox/temp" #Dossier temporaire pour decompresser l'archive
log_fichier="$tmp_dossier/var/log/auth.log"
admin_tmp=".sh-toolbox/admin_tmp" #

if [ $# -ne 1 ];then
	echo "Erreur d'usage: ./restore-archive.sh <chemin>"
	exit 1
fi

#Verifier l'existence du dossier .sh-toolbox
if [ ! -d "./sh-toolbox" ] ; then
	echo ".sh-toolbox n'existe pas "
	exit 1
fi

#Créer le dossier destination s'il nexiste pas
if [ ! -d "$1" ];then
	mkdir "$1"
	if [ $? -ne 0 ];then
		echo " $1 n'a pas pu etre créé"
		exit 2
	fi
fi


# Afficher les archives disponibles
echo "Archives :"
i=1
tail -n +2 "$fichier_archives" | while IFS=":" read nom reste ; do
	echo "$i) $nom"
	i=$((i+1))
done
echo ""

# Choisir une archive 
echo "Selectionnez une archive (1/2.......) : " 
read choix

# Recuperer le nom de l'archive 
i=0
while IFS=":" read nom reste; do
	# ignorer la premiere ligne
	if [ $i -eq 0 ]; then 
		i=$((i+1))
		continue
	fi
	
	if [ $i -eq $choix ]; then
		nom_archive=$nom #Recuperer le nom de l'archive
		break
	fi
	i=$((i+1))
done < "$fichier_archives"

archive="$dossier/$nom_archive" #Chemin de l'archive 

# Verifier l'existence de cette archive dans le dossier .sh-toolbox
if [ ! -f "$archive" ]; then
    echo "Erreur : l'archive '$nom_archive' n'existe pas dans $dossier."
    exit 2
fi

# Creer le dossier temporaire s'il n'existe pas
if [ ! -d $tmp_dossier ];then
	mkdir  "$tmp_dossier"
fi

# Decompression de l’archive dans le dossier temporaire.
tar -xzf "$archive" -C "$tmp_dossier" #extraire l’archive 
if [ $? -ne 0 ]; then
    echo "Erreur : echec de la décompression."
    exit 3
    rm -rf "$tmp_dossier" # Suppression de tmp_dossier
fi



# Verifier l'existence du fichier Log 
if [ ! -f "$log_fichier" ]; then
    echo "Erreur : fichier de logs introuvable."
    exit 4
    rm -rf "$tmp_dossier"
fi


# Récuperer toutes les tentatives de connexions réussies de admin et copier la derniere tentative dans la variable "admin"
admin=$(grep "Accepted password for admin" "$log_fichier" | tail -n 1)


# Récuperer la date et l'heure de la derniere connexion de admin
mois=$(echo "$admin" | cut -d' ' -f1)
jour=$(echo "$admin" | cut -d' ' -f2)
heure=$(echo "$admin" | cut -d' ' -f3)


find "$data_dossier" -type f > "$data_tmp" # Copier tous les fichiers qui existent dans le dossier data dans un fichier temporaire










rm -rf "$tmp_dossier" # Suppression de tmp_dossier
exit 0
