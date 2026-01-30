#!/bin/bash


fichier_archives=".sh-toolbox/archives"
tmp_dossier=".sh-toolbox/temp" #Dossier temporaire pour decompresser l'archive
log_fichier="$tmp_dossier/var/log/auth.log"
admin_tmp=".sh-toolbox/admin_tmp" 
data_dossier="$tmp_dossier/data"
data_tmp=".sh-toolbox/data_tmp" 
fichiers_chiff=".sh-toolbox/fichiers_chiff" #Un fichier pour sauvegarder les fichiers modifiés de l'archive (chiffrés)
fichiers_clairs=".sh-toolbox/fichiers_clair" #Un fichier pour sauvegarder les fichiers non modifiés de l'archive
touch "$fichiers_chiff"
touch "$data_tmp"
touch "$fichiers_clairs"


if [ $# -ne 1 ];then
	echo "Erreur d'usage: ./restore-archive.sh <chemin>"
	exit 1
fi

#Verifier l'existence du dossier .sh-toolbox
if [ ! -d ".sh-toolbox" ] ; then
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
		nom_archive="$nom" #Recuperer le nom de l'archive
		break
	fi
	i=$((i+1))
done < "$fichier_archives"

archive=".sh-toolbox/$nom_archive" #Chemin de l'archive 

# Verifier l'existence de cette archive dans le dossier .sh-toolbox
if [ ! -f "$archive" ]; then
    echo "Erreur : l'archive '$nom_archive' n'existe pas dans .sh-toolbox."
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
date_connexion_admin=$(date -d "$mois $jour $heure" +%s) # Transformer la date de la derniere connexion de l'admin en format unix ( on va l'utiliser plus pour comparer avec la date de modification des fichiers)


find "$data_dossier" -type f > "$data_tmp" # Copier tous les fichiers qui existent dans le dossier data dans un fichier temporaire



while read fichier ; do
	# Recuperer la date de modification / utilisateur / permissions de chaque fichier
	date_modif_fichier=$(stat -c %Y "$fichier")
    	utilisateur=$(stat -c %U "$fichier")
    	perm=$(stat -c %a "$fichier")
	
	# Comparer la date de modification du fichier avec la date de la derniere connexion de admin
	if [ "$date_modif_fichier" -ge "$date_connexion_admin" ] ;then 
		 echo "$fichier" >> "$fichiers_chiff" #Sauvegarder les fichiers modifiés dans un fichier temporaire 

	else
		if [ "$utilisateur" != "admin" ] ; then  # Vérifier si le fichier n'appartient pas à "admin"
		    	if [ $(($perm % 10)) -eq 4 ] || [ $(($perm % 10)) -eq 5 ] ;then #Vérifier si le fichier posséde la permission de lecture
		    		echo "$fichier" >> "$fichiers_clairs" # Sauvegarder les fichiers non modifiés dans un fichier temporaire 
			fi
		fi
    	fi
done  < "$data_tmp"


# Trouver la version non chiffrée d'un fichier chiffré (peut y avoir des fichiers chiffrés mais leurs version clairs n'existe pas dans l'archive 
# comme dans l'archive client2 on a des fichiers qui sont chiffrés mais on trouve pas leurs versions claires )
trouve=0
while read f_chiffre; do
	# Arreter si on a déja trouver un fichier déchiffrer qui correspond á un fichier chiffré
	if [ $trouve -eq 1 ];then
		break
	fi
	
	nom=$(basename "$f_chiffre")
    	taille=$(stat -c %s "$f_chiffre")
    	version_chiffre="$f_chiffre"
    	while read f_clair; do
		if [ "$(basename "$f_clair")" != "$nom" ] ;then # Verifier si c'est le méme nom
			continue
		fi
		taille_clair=$(stat -c %s "$f_clair")
		if [ $taille_clair -ne $taille ] ;then # Vérifier la taille
			continue
		fi
		version_clair="$f_clair"
		trouve=1
		break
    done < "$fichiers_clairs"
done < "$fichiers_chiff"

# Coder en base64 la version claire et chiffrée
base64 "$version_chiffre" > "src/chiffre64"
base64 "$version_clair" > "src/clair64"

trouve=1
echo ""
echo "Determination de la clé..."

fichier_cle="/tmp/KEY"
resultat=$(./findkey src/clair64 src/chiffre64 -o "$fichier_cle" 2>/dev/null )

if [ $? -ne 0 ]; then
    	echo "Erreur : findkey a échoué (clé non trouvée)"
    	trouve=0
else
	cle64=$(cat "$fichier_cle")
    	echo "Clé trouvée"
    	echo ""
	cle=$(echo "$cle64" | base64 -d) # Decodée la clé
	echo "Clé en base64 :$cle64"
   	echo "Clé decodée: $cle"
   	echo ""
   	
   	non_imprimable=$(echo "$cle" | tr -d '[:print:]')
	if [ -n "$non_imprimable" ]; then
	    echo "La clé contient des caractères non imprimables"
	    nom_archive_net=$(echo "$nom_archive" | sed -n 's/^\(.*\)\.tar\.gz/\1/p') # Recupérer le nom de l'archive sans .tar.gz
	    dossier_cle=".sh-toolbox/$nom_archive_net"
	    mkdir -p "$dossier_cle"
	    mv "$fichier_cle" "$dossier_cle/KEY"
	    type="f"
	else
	    type="s"
	fi
fi


# Enregistrer la clé
if [ "$type" = "s" ];then
	sed -i "s/^\($nom_archive:[^:]*:\).*/\1$cle:s/" .sh-toolbox/archives
	echo "La clé est stockée dans le fichier arhives"
else
	sed -i "s/^\($nom_archive:[^:]*:\).*/\1:f/" .sh-toolbox/archives
	echo "La clé est stockée dans le fichier $dossier_cle/KEY"
fi
if [ $? -ne 0 ];then
	echo "Erreur: impossible de mettre á jout le fichier archives"
	exit 2
fi


# Supprimer /tmp/KEY s'il existe
if [ -f "$fichier_cle" ];then
	rm "$fichier_cle"
fi

echo ""

#Dechifrement des fichiers 
destination=$1
mkdir -p tmp
if [ $trouve -ne 0 ];then
	echo "Déchiffrement des fichiers..."
	
	
	trouve=0
	while read f_chiffre; do
		chemin_relatif=$(echo "$f_chiffre" | sed "s/^.sh-toolbox\/temp\/\(.*\)/\1/") # Recuperer le chemin relatif des fichiers depuis l'archive
		chemin_absolu="$destination/$chemin_relatif" # Définir le chemin final dans le dossier destination
		chemin_parent=$(dirname $chemin_absolu) # Recupérer le chemin du dossier parent 
		
		# Créer le dossier s'il n'existe pas
		if [ ! -d "$chemin_parent" ];then
			mkdir -p "$chemin_parent"
		fi 
		
		# Verifier si le fichier existe déjà c'est à dire il déjà été dechiffré
		if [ -f "$chemin_absolu" ];then
			read -p "La version dechiffrée "$chemin_absolu" existe déjà, voulez-vous l'écraser (1:oui / 0:non) " reponse </dev/tty
			if [ "$reponse" = "0" ];then
				continue
			fi
		fi
		
		# encoder le fichier en base64
		base64 "$f_chiffre" > tmp/chiffre64.txt
		
		# Déchiffrer
		./decipher "$cle64" tmp/chiffre64.txt >/dev/null
		
		
		#Verifier si le fichier a été bien dechiffré
		if [ $? -ne 0 ];then
			trouve=1
			continue
		fi
		base64 -d tmp/chiffre64.txt > "$chemin_absolu" 2>/dev/null

		
		
	done < "$fichiers_chiff"
	if [ $trouve -ne 0 ];then
		echo ""
		echo "Erreur: l'un des fichiers n'a pas pu etre déchiffré"
		rm -r tmp
		rm "src/chiffre64"
		rm "src/clair64"
		rm  "$data_tmp" 
		rm  "$fichiers_chiff"
		rm "$fichiers_clairs"
		rm -rf "$tmp_dossier" 
		exit 4
	fi



	echo "Déchiffrement terminé"
else
	echo "Erreur: dechifrement echoué (la clé n'est pas trouvée)"
fi

rm -r tmp
rm "src/chiffre64"
rm "src/clair64"
rm  "$data_tmp" 
rm  "$fichiers_chiff"
rm "$fichiers_clairs"
rm -rf "$tmp_dossier" 
exit 0
