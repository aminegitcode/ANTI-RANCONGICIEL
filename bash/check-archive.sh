#!/bin/bash

# Vérifie le dossier .sh-toolbox
dossier=".sh-toolbox"
fichier_archives="$dossier/archives"
if [ ! -d "$dossier" ]; then
    echo "Erreur : le dossier '$dossier' n'existe pas."
    exit 1
fi
if [ ! -f "$fichier_archives" ]; then
    echo "Erreur : le fichier '$fichier_archives' n'existe pas."
    exit 2
fi

# Liste les archives disponibles
echo "Archives disponibles :"
tail -n +2 "$fichier_archives" | while IFS=":" read nom date cle ; do
	echo "$nom"
done
echo ""

read -p "Entrez le nom d'une archive : " nom_archive
archive="$dossier/$nom_archive"

if [ ! -f "$archive" ]; then
    echo "Erreur : l'archive '$nom_archive' n'existe pas dans $dossier."
    exit 2
fi

# Création d’un dossier temporaire
tmp_dossier="$dossier/temp"
mkdir  "$tmp_dossier"

# Décompression de l’archive dans le dossier temporaire.
tar -xzf "$archive" -C "$tmp_dir" #extraire l’archive gzip dont le nom est dans "$archive"
if [ $? -ne 0 ]; then
    echo "Erreur : échec de la décompression."
    exit 3
fi

# Recherche du fichier log
log_file=$(find "$tmp_dir" -type f -path "*/var/log/auth*.log" | head -n 1)
if [ -z "$log_file" ]; then
    echo "Erreur : fichier de logs introuvable."
    exit 4
fi

exit 0

