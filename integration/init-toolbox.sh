#!/bin/bash
# on verifie que aucun parametre est donnee au moment de l'execution
if [ $# -ne 0 ] ; then
	echo "Erreur: pas besoin d'arguments"
	exit 1
fi

echo "Initialisation de l'environnement de travail..."

echo " " # pour sauter une ligne

dossier_toolbox=".sh-toolbox"

# verifier si le dossier tool-box existe deja / s'il existe pas on va le creer
if [ -d $dossier_toolbox ] ; then
	echo "Le dossier $dossier_toolbox existe déja"
else
	echo "Création du dossier $dossier_toolbox ..."
	mkdir $dossier_toolbox

	#verifier si le dossier a ete cree avec succes
	if [ $? -eq 0 ] ;then
		echo "Création rèussi !"
	else
		echo "Le dossier $dossier_toolbox n'a pas pu etre crée"
		exit 1
	fi
fi


fichier_archives="archives"
chemin_archives=".sh-toolbox/archives"
echo " "

# verifier l'existence du fichier archives dans .sh-toolbox
if [ -f $chemin_archives ] ; then
	echo "Le fichier $fichier_archives existe déja dans $dossier_toolbox"
else
	echo "Création du fichier $fichier_archives ..."
	echo 0 > $chemin_archives
	if [ $? -eq 0 ] ; then
		echo "Création réussi !"
	else
		echo "Le fichier $fichier_archives n'a pas pu etre crée"
		exit 1
	fi
fi


# verifier si d'autres fichiers ou dossiers se trouvent dans .sh-toolbox
nb_lignes=` ls .sh-toolbox | grep -v  "archives" | wc -l`
if [ $nb_lignes -ne 0 ]; then
	echo ""
	echo "d'autres fichiers/dossiers existent dans le dossier sh-toolbox"
	exit 2
fi
echo " "

# Vérification des sources dans src/
src_dossier="src"

if [ ! -d "$src_dossier" ]; then
    echo "Erreur : dossier src/ manquant."
    exit 10
fi

if [ ! -f "$src_dossier/Makefile" ]; then
    echo "Erreur : Makefile manquant dans src/"
    exit 10
fi

for fichier in decipher.c findkey.c vigenere.c vigenere.h; do
    if [ ! -f "$src_dossier/$fichier" ]; then
        echo "Erreur : fichier source manquant : src/$fichier"
        exit 10
    fi
done

# Vérification du compilateur

if ! command -v gcc >/dev/null 2>&1; then
    echo "Erreur : le compilateur gcc n'est pas disponible."
    exit 11
fi

# Compilation via Makefile
echo ""
echo "Compilation des binaires findkey et decipher..."
# Compiler decipher si absent
if [ ! -f "decipher" ]; then
    echo "Compilation de decipher ..."
    cd "$src_dossier"
    make decipher
    
    if [ $? -ne 0 ]; then
        echo "Erreur : la compilation de decipher a échoué."
        exit 12
    fi
    cd ..

    cp "$src_dossier/decipher" .
fi
echo ""

# Compiler findkey si absent
if [ ! -f "findkey" ]; then
    echo "Compilation de findkey ..."
    cd "$src_dossier"
    make findkey

    if [ $? -ne 0 ]; then
        echo "Erreur : la compilation de findkey a échoué."
        exit 12
    fi
    cd ..

    cp "$src_dossier/findkey" .
fi

echo ""
echo "Compilations terminées avec succès !"
echo "Initialisation terminée avec succès !"
echo "Nettoyage des fichiers objets..."
cd src
make clean >/dev/null 2>&1
cd ..

exit 0

