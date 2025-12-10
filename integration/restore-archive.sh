#!/bin/bash


$fichier_archives="./sh-toolbox/archives"


if [ $# -ne 1 ];then
	echo "Erreur d'usage: ./restore-archive.sh <chemin>"
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
		nom_archive=$nom
		break
	fi
	i=$((i+1))
done < "$fichier_archives"



