#!/bin/bash

if [ $# -ne 0 ] ; then
	echo "Erreur: pas besoin d'arguments"
	exit 1
fi

echo " Identification des problemes..."
dossier_toolbox=.sh-toolbox
fichier_archives=archives
chemin_fichier_archives="$dossier_toolbox/$fichier_archives"

reponse1=0
reponse2=0
reponse3=0


# verifier l'existence du dossier sh-toolbox
if [ ! -d $dossier_toolbox ]; then
	echo "Le fichier $dossier_toolbox n'existe pas"
	echo "voulez vous initialiser l'environnement de travail (1:oui / 0:non)"
	read reponse1
	echo ""
fi

#verifier l'existence du fichier archives
if [ ! -f "$chemin_fichier_archives" ]; then 
	echo "Le fichier $fichier_archives n'existe pas"
	echo "Voulez-vous creer le fichier archives ? (1:oui / 0:non)"
	read reponse2
fi







echo ""
# creation du dossier .sh-toolbox avec le fichier archives en utilisant ./init-toolbox
if [ $reponse1 -eq 1 ] ; then 
	echo "creation du dossier '.sh-toolbox'..."
	./init-toolbox.sh
	if [ $? -eq 0 ] ;then
		echo "Creation reussi !"
	else
		echo "erreur d'initialisation"
		exit 1
	fi
fi

# creation du fichier archives 
if [ $reponse2 -eq 1 ] ; then 
	echo "creation du fichier 'archives'..."
	echo 0 > archives
	
	if [ $? -eq 0 ] ;then
		echo "Creation reussi !"
	else
		echo "erreur de creation"
		exit 1
	fi
fi



echo "L'environnement de travail est bien initialise"
exit 0
