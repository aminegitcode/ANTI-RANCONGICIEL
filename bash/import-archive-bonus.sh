#!/bin/bash


# Vérification des arguments
if [ $# -lt 1 ]; then
    echo "Usage: $0 [-f] archive1 [archive2 ...]"
    exit 2
fi

# Gestion de l'option -f
force=0
if [ "$1" == "-f" ]; then
    force=1
    shift
fi

# Dossier et fichier archives
dossier=".sh-toolbox"
fichier_archives="$dossier/archives"

# Boucle sur chaque archive passée en argument
for archive in "$@"; do
	nom_archive=$(basename "$archive")
	
	# Vérifie que l’archive existe
	if [ ! -f "$archive" ]; then
		echo "Erreur : le fichier archive '$archive' n'existe pas."
		exit 2
	fi

	# Gestion des fichiers existants dans le dossier
	if [ -f "$dossier/$nom_archive" ]; then
        	if [ $force -eq 0 ]; then
        		echo ""
			echo "Le fichier '$nom_archive' existe déja dans '$dossier'."
			read -p "Voulez-vous l'écraser ? (oui/non) : " reponse
            		if [ "$reponse" != "oui" ]; then
                		echo "Copie ignorée pour '$nom_archive'."
                		continue
			fi
		fi
	fi

	# Copie de l'archive
	cp "$archive" "$dossier/"
	if [ $? -ne 0 ]; then
        	echo "Erreur : problème lors de la copie de '$nom_archive'."
        	exit 3
	fi
    
	echo "Archive '$nom_archive' copiée dans le dossier."
   
   
   
	
	date_ajout=$(date +"%d%m%y%H%M%S")
	# Mise à jour du fichier archives
	if grep -q "^$nom_archive:" "$fichier_archives"; then
		# Archive déjà présente → on met à jour sa date
		touch ".sh-toolbox/tmp"
		tmp_file=".sh-toolbox/tmp"
		
		# On saute la première ligne (le compteur)	
		compteur=$(head -n 1 "$fichier_archives")
		echo "$compteur" > "$tmp_file"

		# On lit les lignes suivantes
		tail -n +2 "$fichier_archives" | while IFS=":" read -r nom date cle; do
	        if [ "$nom" = "$nom_archive" ]; then
	            echo "$nom:$date_ajout:$cle" >> "$tmp_file"
	        else
	            echo "$nom:$date:$cle" >> "$tmp_file"
	        fi
	    done
	
		mv "$tmp_file" "$fichier_archives"
		echo "Date mise à jour pour '$nom_archive'."
	    
		if [ -f $tmp_file ] ; then
			rm $tmp_file
		fi
	
		        
        
    else
    	touch ".sh-toolbox/tmp"
	tmp_file=".sh-toolbox/tmp"
        compteur=$(head -n 1 "$fichier_archives")
        compteur=$((compteur + 1))
       

        {
            echo "$compteur" 
            tail -n +2 "$fichier_archives" 
            echo "$nom_archive:$date_ajout:" 
        } > "$tmp_file"
        
        cat "$tmp_file" > ".sh-toolbox/archives"
        if [  $? -ne 0 ] ; then 
        	echo "Erreur : mise à jour du fichier archives impossible."
            exit 4
	fi
	if [ -f $tmp_file ] ; then
			rm $tmp_file
	fi

        echo "Nouvelle archive '$nom_archive' ajoutée dans l'historique."
    fi
done


   

exit 0

