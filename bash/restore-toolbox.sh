#!/bin/bash

if [ $# -ne 0 ] ; then
	echo "Erreur: pas besoin d'arguments"
	exit 1
fi

echo " Identification des problemes..."

./ls-toolbox.sh > dev/null

reponse1=0
reponse2=0
reponse3=0

# appeler ls-toolbox pour avoir le code de sortie qui permet d'identifier les problemes et on rederige sa sorte vers dev/null
./ls-toolbox.sh > dev/null

case $? in 
	0 )
	echo "l'environnement de travail n'est pas corrompu ";;

	1 )
	echo "Le dossier '.sh-toolbox' n'existe pas"
	read -p "voulez vous le creer ?  1:oui / 0:non " reponse1;;
	
	2 ) 
	echo "Le fichier 'archives' n'existe pas "
	read -p "voulez vous le creer ?  1:oui / 0:non " reponse2;;
	
	3 )
	echo "Archive inexistante mentionnée dans le fichier. archives OU 
	Archive présente dans .sh-toolbox et non mentionnée dans le fichier. archives";;
	reponse3=1
	
esac

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
