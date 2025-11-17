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
read -p "Selectionnez une archive (1/2.......) : " choix


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
done < $fichier_archives

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
fi


log_fichier="$tmp_dossier/var/log/auth.log"

# Verifier l'existence du fichier Log 
if [ ! -f "$log_fichier" ]; then
    echo "Erreur : fichier de logs introuvable."
    exit 4
fi

echo "$log_fichier"




rm -rf $tmp_dossier
exit 0

