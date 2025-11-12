#!/bin/bash

# on verifie que accun parametre est donnee au momnet de l'execution
if [ $# -ne 0 ] ; then
	echo "Erreur: pas besoin d'arguments"
	exit 1
fi

echo "Initialisation de l'environnement de travail..."

echo " " # pour sauter une ligne

dossier_toolbox=".sh-toolbox"

# verifier si le dossier tool-box existe deja / s'il existe pas on va le creer
if [ -d $dossier_toolbox ] ; then
	echo "Le dossier $dossier_toolbox existe deja"
else
	echo "Creation du dossier $dossier_toolbox ..."
	mkdir $dossier_toolbox

	#verifier si le dossier a ete cree avec succes
	if [ $? -eq 0 ] ;then
		echo "Creation reussi !"
	else
		echo "Le dossier $dossier_toolbox n'a pas pu etre cree"
		exit 1
	fi
fi


fichier_archives="archives"
chemin_archives=".sh-toolbox/archives"
echo " "

# verifier l'existence du fichier archives dans .sh-toolbox
if [ -f $chemin_archives ] ; then
	echo "Le fichier $fichier_archives existe deja dans $dossier_toolbox"
else
	echo "Creation du fichier $fichier_archives ..."
	echo 0 > $chemin_archives
	if [ $? -eq 0 ] ; then
		echo "Creation reussi !"
	else
		echo "Le fichier $fichier_archives n'a pas pu etre cree"
		exit 1
	fi
fi


# verifier si d'autres fichiers ou dossiers se trouvent dans .sh-toolbox
nb_lignes=` ls .sh-toolbox | grep -v  "archives" | wc -l`
if [ $nb_lignes -ne 0 ]; then
	echo "d'autres fichiers/dossiers existent dans le dossier sh-toolbox"
	exit 2
fi
echo " "
echo "Initialisation terminee avec succes !"
exit 0
