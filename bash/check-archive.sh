#!/bin/bash


dossier=".sh-toolbox"
fichier_archives="$dossier/archives"

# Verifier l'existence du dossier .sh-toolbox
if [ ! -d "$dossier" ]; then
    echo "Erreur : le dossier '$dossier' n'existe pas."
    exit 1
fi

# Verifier l'existence du fichier archives
if [ ! -f "$fichier_archives" ]; then
    echo "Erreur : le fichier '$fichier_archives' n'existe pas."
    exit 2
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
		nom_archive=$nom
		break
	fi
	i=$((i+1))
done < "$fichier_archives"

archive="$dossier/$nom_archive"

# Verifier l'existence de cette archive dans le dossier .sh-toolbox
if [ ! -f "$archive" ]; then
    echo "Erreur : l'archive '$nom_archive' n'existe pas dans $dossier."
    exit 2
fi


tmp_dossier="$dossier/temp"

# Creer le dossier temporaire s'il n'existe pas
if [ ! -d $tmp_dossier ];then
	mkdir  "$tmp_dossier"
fi

# Decompression de l’archive dans le dossier temporaire.
tar -xzf "$archive" -C "$tmp_dossier" #extraire l’archive gzip dont le nom est dans "$archive"
if [ $? -ne 0 ]; then
    echo "Erreur : echec de la décompression."
    exit 3
    rm -rf "$tmp_dossier" # forcer la suppression de "tmp_dossier" avec -f
fi


log_fichier="$tmp_dossier/var/log/auth.log"
echo "$log_fichier"

# Verifier l'existence du fichier Log 
if [ ! -f "$log_fichier" ]; then
    echo "Erreur : fichier de logs introuvable."
    exit 4
    rm -rf "$tmp_dossier" # forcer la suppression de "tmp_dossier" avec -f
fi

# Demander si l'utilisateur s'il veut afficher le fichier log
echo "Voulez-vous parcourir et affficher le fichier Log (1:oui / 0:non)"
read reponse
if [ $reponse -eq 1 ]; then
	while read ligne ; do	
		echo "$ligne"
	done < "$log_fichier"
fi


log_tmp="$dossier/tmp_log"

# Recuperer toutes les tentatives de connexions reussies de admin et copier la derniere tentative dans un fichier temporaire 
grep "Accepted password for admin" "$log_fichier" | tail -n 1 > "$log_tmp"


# Recuperer et afficher la date et l'heure de la derniere connexion de admin
read mois jour heure reste < "$log_tmp"
echo ""
echo "La derniere connexion de l’utilisateur  'admin' :"
echo "$mois $jour $heure"
echo ""






# Afficher les fichiers modifiés  apres la derniere connexion de admin
data_dossier="$tmp_dossier/data"
data_tmp="$dossier/data_tmp"
data_modifie_tmp="$dossier/data_modifie_tmp" #Un fichier pour sauvegarder les fichiers modifiés de l'archive
touch "$data_modifie_tmp"
# Vérifier si le dossier de données est vide
if [ ! "$(ls -A "$data_dossier")" ]; then
    echo "Erreur : le dossier '$data_dossier' est vide."
    exit 5
    rm -rf "$tmp_dossier" # forcer la suppression de "tmp_dossier" avec -f
fi

find "$data_dossier" -type f > "$data_tmp" # Copier tous les fichiers qui existent dans le dossier data dans un fichier temporaire
date_connexion_admin=$(date -d "$mois $jour $heure" +%s) # Transformer la date de la derniere connexion de l'admin en format unix ( on va l'utiliser plus pour comparer avec la date de modification des fichiers)


echo "Fichiers modifiés aprés la derniere connexion de admin :"
nb_fich=0
while read fichier ; do
	# Recuperer la date de modification du fichier 
	date_modif_fichier=$(stat -c %Y "$fichier")
	
	# Comparer la date de modification du fichier avec la date de la derniere connexion de admin
	if [ "$date_modif_fichier" -gt "$date_connexion_admin" ] ;then 
		echo "$fichier"
		 echo "$fichier" >> "$data_modifie_tmp" #Sauvegarder le fichier modifié dans un fichier temporaire 
		
		nb_fich=$((nb_fich+1))
	fi
done  < "$data_tmp"
# Afficher un message si accun fichier n'est trouvé
if [ $nb_fich -eq 0 ] ;then
	echo "Accun fichier trouvé"
fi


echo ""





#Partie bonus
echo "Fichiers non modifiés après la dernière connexion de admin, en lecture seule, et qui n'appartiennent pas à admin :"
nb_fich=0
while read fichier ; do
    # Vérifier si le fichier est en lecture seule
    permissions=$(stat -c %a "$fichier")  # Récupérer les permissions du fichier 
    
    # Vérifier si la dernière permission est égale à 4 (lecture seule)
   if [ $(($permissions % 10)) -eq 4 ]; then  # Vérifie si le fichier est en lecture seule 
        
        # Vérifier si le fichier n'appartient pas à "admin"
        utilisateur=$(stat -c %U "$fichier")
        if [ "$utilisateur" != "admin" ]; then

            # Vérifier la date de modification du fichier
            date_modif_fichier=$(stat -c %Y "$fichier")

            # Comparer la date de modification du fichier avec la date de la derniere connexion de admin
            if [ "$date_modif_fichier" -lt "$date_connexion_admin" ]; then
                # Vérifier si le fichier porte le même nom et a la même taille que l'un des fichiers modifiés
                taille_fichier=$(stat -c %s "$fichier")
               
                # Comparer le nom et la taille avec les fichiers modifiés
                for fichier_modif in $(cat "$data_modifie_tmp"); do
                    taille_fichier_modif=$(stat -c %s "$fichier_modif")
                    nom_fichier_modif=$(basename "$fichier_modif")
                    if [ "$(basename "$fichier")" == "$nom_fichier_modif" ] && [ "$taille_fichier" -eq "$taille_fichier_modif" ]; then
                        echo "$fichier correspond au fichier modifié '$fichier_modif' "
                        nb_fich=$((nb_fich + 1))
                    fi
                done
            fi
        fi
    fi
done < "$data_tmp"


# Afficher un message si aucun fichier correspondant n'est trouvé
if [ $nb_fich -eq 0 ]; then
    echo "Aucun fichier trouvé"
fi 


# Suprimer les fichiers et dossiers temporaires
rm "$data_tmp"
rm "$data_modifie_tmp"
rm "$log_tmp"
rm -rf "$tmp_dossier" # forcer la suppression de "tmp_dossier" avec -f
exit 0

