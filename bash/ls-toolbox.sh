#!/bin/bash
# assurer que le script n'a pas de paramtres 
if [ $# -ne 0 ]; then
	echo "Erreur: le script n'a pas besoin de paramtres"
	exit 1
fi

dossier_toolbox=.sh-toolbox
fichier_archives=archives
chemin_fichier_archives=$dossier_toolbox/$fichier_archives

echo "Archives: "
echo " "

# verifier l'existence du dossier sh-toolbox
if [ ! -d $dossier_toolbox ]; then
	echo "Le fichier $dossier_toolbox n'existe pas"
	exit 1
elif [ ! -f "$dossier_toolbox/$fichier_archives" ]; then #verifier l'existence du fichier archives
	echo "Le fichier $fichier_archives n'existe pas"
	exit 2
fi

# une variable qu'on va utiliser dans la suite pour determiner si une archive mentionnee dans le fichier archives n'exsite pas 
# on suppose que toutes les archives existent
existe=1

# lire les lignes du fichier
while IFS=":" read nom date cle; do
	echo "Nom: $nom "
	echo "Date: $date"
	echo "Cle: $cle"
	echo "------------"
	
	# verifier si cette archive n'exsite pas 
	if [ ! -f "$dossier_toolbox/$nom" ] ; then 
		existe=0 
	fi
	
done < "$chemin_fichier_archives"


if [ $existe -eq 0 ]; then
	echo "il existe une archive presente dans le fcihier 'archives' mais n'existe pas dans le dossier '.sh-toolbox'"
	exit 3
fi


for fichier in "$dossier_toolbox"/*.gz; do
    nom_fichier=$(basename "$fichier")

    # on envoie son résultat vers /dev/null pour ne rien afficher
    if [ ! grep "^$nom_fichier:" "$chemin_fichier_archives" >/dev/null ]; then
        echo "Avertissement: $nom_fichier existe dans $dossier_toolbox mais n'est pas mentionné dans $fichier_archives"
        exit 3
    fi
done
