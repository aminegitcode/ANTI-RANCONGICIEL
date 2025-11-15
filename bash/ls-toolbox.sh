#!/bin/bash
# assurer que le script n'a pas de paramtres 
if [ $# -ne 0 ]; then
	echo "Erreur: le script n'a pas besoin de paramtres"
	exit 1
fi

dossier_toolbox=.sh-toolbox
fichier_archives=archives
chemin_fichier_archives="$dossier_toolbox/$fichier_archives"

echo "Archives: "
echo " "

# verifier l'existence du dossier sh-toolbox
if [ ! -d $dossier_toolbox ]; then
	echo "Le fichier $dossier_toolbox n'existe pas"
	exit 1
elif [ ! -f "$chemin_fichier_archives" ]; then #verifier l'existence du fichier archives
	echo "Le fichier $fichier_archives n'existe pas"
	exit 2
fi

# une variable qu'on va utiliser dans la suite pour determiner si une archive mentionnee dans le fichier archives n'exsite pas dans le dossier .sh-toolbox
# on suppose que toutes les archives existent
existe=1

archive_existe_pas=""
compteur=0
# lire les lignes du fichier
while IFS=":" read nom date cle; do
	#Verifier qu'on va lire la premiere ligne
 	if [ $compteur -eq 0 ] ; then 
 		compteur=$((compteur + 1))
 		continue
 	fi
 	
	echo "Nom: $nom "
	echo "Date: $date"
	echo "Cle: $cle"
	echo ""

	
	# verifier si cette archive n'exsite pas 
	if [ ! -f "$dossier_toolbox/$nom" ] ; then 
		existe=0 
		archive_existe_pas=$nom
	fi
	
done < "$chemin_fichier_archives"


if [ $existe -eq 0 ]; then
	echo "Erreur: l'archive $archive_existe_pas est presente dans le fcihier 'archives' mais n'existe pas dans le dossier '.sh-toolbox'"
	exit 3
fi

# verifier si une archive existe dans le dossier .sh-toolbox mais n'est pas dans le fichier archives
for fichier in "$dossier_toolbox"/*.gz; do
    nom_fichier=$(basename "$fichier")

    
    if  ! grep -q "^$nom_fichier:" "$chemin_fichier_archives"  ; then
        echo "Avertissement: $nom_fichier existe dans $dossier_toolbox mais n'est pas mentionné dans le fichier '$fichier_archives'"
        exit 3
    fi
done



exit 0
