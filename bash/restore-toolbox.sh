#!/bin/bash

if [ $# -ne 0 ] ; then
	echo "Erreur: pas besoin d'arguments"
	exit 1
fi

echo "Réstauration de l'environnement de travail..."
echo ""
dossier_toolbox=.sh-toolbox
fichier_archives=archives
chemin_fichier_archives="$dossier_toolbox/$fichier_archives"


# verifier l'existence du dossier sh-toolbox
if [ ! -d $dossier_toolbox ]; then
	echo "Le fichier $dossier_toolbox n'éxiste pas"
	echo "voulez vous initialiser l'environnement de travail (1:oui / 0:non)"
	echo ""
	# Creation et initialisation du dossier .sh-toolbox
	./init-toolbox.sh
	if [ $? -ne 0 ]; then 
		echo "Echec d'initialisation"
	fi
	echo ""
else
	echo "Le dossier $dossier_toolbox existe"
fi

#verifier l'existence du fichier archives
if [ ! -f "$chemin_fichier_archives" ]; then 
	echo "Le fichier $fichier_archives n'existe pas"
	echo "Voulez-vous créer le fichier archives ? (1:oui / 0:non)"
	read rep
	
	if [ $rep -eq 1 ] ; then
		# Création et initialisation du fichier 'archives'
		echo "création du fichier 'archives'..."
		echo 0 > $chemin_fichier_archives
		if [ $? -eq 0 ] ;then
			echo "Création réussi !"
		else
			echo "erreur de création du fichier '$fichier_archives'"
			exit 1
		fi
	else
		echo "Impossible de continuer sans le fichier 'archvies'"
		exit 2
	fi
else
	echo "Le fichier $fichier_archives existe"
fi


# verifier si des archives existent dans le fichier 'archives' mais pas dans le dossier '.sh-toolbox'
tail -n +2 "$chemin_fichier_archives" | while IFS=":" read nom date cle; do

	# Verification pour chaque archive 
	if [ ! -f "$dossier_toolbox/$nom" ] ; then 
		echo "L'archive '$nom' existe dans '$fichier_archives' mais n'existe pas dans le dossier '$dossier_toolbox'"
		read -p "Voulez-vous supprimer  '$nom'  du fichier '$fichier_archives' ? (1:oui / 0:non)" reponse0 </dev/tty #Forcer read á lire depuis l'entré standard 
		
		# Suppression de cette archive
		if [ $reponse0 -eq 1 ] ; then
		
			echo "suppression en cours..."
			# Creer un fichier temporaire 
			fichier_tmp="$dossier_toolbox/tmp"
			#Recuperer et decrementer la 1er ligne 
			compteur=$(head -n 1 "$chemin_fichier_archives")
        		compteur=$((compteur - 1))
			echo "$compteur" > "$fichier_tmp"
			tail -n +2 "$chemin_fichier_archives" | grep -v "^$nom" >> "$fichier_tmp"
			
			# copier le fichier tmp dans 'archives'
			mv "$fichier_tmp" "$chemin_fichier_archives"
			if [ $? -eq 0 ]; then
				echo "suppression réussie "
			else
				echo "Echec de suppression"
			fi
			
			#Supprimer le fichier temporaire
			if [ -f $fichier_tmp ] ; then
				rm $fichier_tmp
			fi
		fi
		
	fi
done 

echo ""

# verifier si une archive existe dans le dossier .sh-toolbox mais n'est pas dans le fichier archives
for fichier in "$dossier_toolbox"/*.gz; do
    nom_fichier=$(basename "$fichier")
	# Verifier l'existence du fichier selectioné pour eviter le cas le oú accun fichier existe et "$dossier_toolbox/*.gz" sera consideré comme un nom de fichier
    if [ ! -e "$fichier" ];then 
    	continue
    fi
    
	if  ! grep -q "^$nom_fichier:" "$chemin_fichier_archives"  ; then
	        echo "Avertissement: $nom_fichier existe dans $dossier_toolbox mais n'est pas mentionné dans le fichier '$fichier_archives'"
	        echo "Voulez-vous supprimer le fichier $fichier du dossier $dossier_toolbox ? (1:oui / 0:non)"
	        read reponse1
		if [ $reponse1 -eq 1 ] ; then
        		echo "suppression en cours..."
        		rm "$fichier"
        		if [ $? -eq 0 ]; then
        			echo "suppression réussie"
        		else
        			echo "Echec de suppression"
        		fi
        		echo ""
    		fi	
	fi
done


echo "Réstauration réussie "
exit 0
