#!/bin/bash

if [ $# -ne 0 ] ; then
	echo "Erreur: pas besoin d'arguments"
	exit 1
fi

echo "Restauration de l'environnement de travail..."
dossier_toolbox=.sh-toolbox
fichier_archives=archives
chemin_fichier_archives="$dossier_toolbox/$fichier_archives"


# verifier l'existence du dossier sh-toolbox
if [ ! -d $dossier_toolbox ]; then
	echo "Le fichier $dossier_toolbox n'existe pas"
	echo "voulez vous initialiser l'environnement de travail (1:oui / 0:non)"
	echo ""
	# Creation et initialisation du dossier .sh-toolbox
	./init-toolbox.sh
	if [ $? -ne 0 ]; then 
		echo "Echec d'initialisation"
	fi
	echo ""
fi

#verifier l'existence du fichier archives
if [ ! -f "$chemin_fichier_archives" ]; then 
	echo "Le fichier $fichier_archives n'existe pas"
	echo "Voulez-vous creer le fichier archives ? (1:oui / 0:non)"
	echo ""
	
	# Creation et initialisation du fichier 'archives'
	echo "creation du fichier 'archives'..."
	echo 2 > $chemin_fichier_archives
	if [ $? -eq 0 ] ;then
		echo "Creation reussi !"
	else
		echo "erreur de creation du fichier '$fichier_archives'"
		exit 1
	fi
	echo""
fi


tail -n +2 "$chemin_fichier_archives" | while IFS=":" read nom date cle; do

	# verifier si cette archive n'exsite pas dans le dossier .sh-toolbox
	if [ ! -f "$dossier_toolbox/$nom" ] ; then 
		echo "L'archive $nom existe dans $fichier_archives mais n'existe pas dans le dossier '$dossier_toolbox'"
		echo "Voulez-vous supprimer $nom du fichier '$fichier_archives' ? (1:oui / 0:non)"
		read reponse
		
		# Suppression de cette archive
		if [ $reponse -eq 1 ] ; then
			# Creer un fichier temporaire 
			fichier_tmp="$dossier_toolbox/tmp"
			head -n 1 > $fichier_tmp
			tail -n +2 "$chemin_fichier_archives" | grep -v "^$nom" >> "$fichier_tmp"
		fi
		mv "$fichier_tmp" "$chemin_fichier_archives"
		
		#Supprimer le fichier temporaire
		if [ -f $fichier_tmp ] ; then
			rm $fichier_tmp
		fi
	fi
done 











echo "L'environnement de travail est bien initialise"
exit 0
