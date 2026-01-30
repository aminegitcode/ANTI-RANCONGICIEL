## Description de la partie integration

Cette partie du projet vise à intégrer les scripts Bash et les programmes C développés précédemment afin de restaurer les fichiers chiffrés d’une archive.


##  Structure des fichiers

.
├── .sh-toolbox
│   ├── archives         
│           
├── check-archive.sh
├── decipher              
├── findkey               
├── import-archive.sh
├── init-toolbox.sh
├── ls-toolbox.sh
├── restore-archive.sh    #
├── restore-toolbox.sh    
└── src
    ├── Makefile
    ├── decipher.c
    └── findkey.c


## script et programmes disponibles
1. init-toolbox.sh 

    -Initialise le dossier .sh-toolbox
    -Vérifie la présence des binaires decipher et findkey.
    -Compile automatiquement findkey et decipher
    -Supprime les fichiers objets (.o) générés pendant la compilation

    **exemple d'execution**
        ./init-toolbox.sh
        Initialisation de l'environnement de travail...
        
        Création du dossier .sh-toolbox ...
        Création rèussi !
         
        Création du fichier archives ...
        Création réussi !
         

        Compilation des binaires findkey et decipher...
        Compilation de decipher ...
        gcc -c decipher.c
        gcc -c vigenere.c
        gcc decipher.o vigenere.o -o decipher 

        Compilation de findkey ...
        gcc -c findkey.c
        gcc findkey.o vigenere.o -o findkey	

        Compilations terminées avec succès !
        Initialisation terminée avec succès !
        Nettoyage des fichiers objets...
                       
2. import-archive.sh

    -Copie l’archive dans .sh-toolbox/
    -Met à jour l’historique (archives)
    -Ajoute ou modifie la date d’ajout
    -Demande confirmation si un fichier existe déjà
    
    Usage :
        ./import-archive.sh [-f] archive1.gz archive2.gz ...

   
3. ls-toolbox.sh
    -Affiche les archives disponibles dans le dossier de travail avec les informations disponibles
    
    **Exemple :**
        └─$ ./ls-toolbox.sh                                 
        Archives: 
        Nom: client2-20250911-1002.tar.gz 
        Date: 251219-061053
        Cle: 
        Type de sauvegarde: 

4. restore-toolbox.sh
    Vérifie :
    -Archives présentes dans archives mais manquantes dans .sh-toolbox
    -Archives présentes dans le dossier mais absentes dans le fichier archives
    -Propose suppression dans le dossier ou l'ajout dans archives ou ne rien faire
    
5. check-archive.sh
    -Demande quelle archive analyser
    -Décompresse l’archive dans .sh-toolbox/temp/
    -Lit var/log/auth.log
    -Trouve la dernière connexion réussie de l’utilisateur admin
    -Afficher les fichiers modifiés 
    -Affiche la liste des fichiers non modifiés qui portent le meme nom et ont la meme taille que chacun des fichiers modifiés
    
    
6. restore-archive.sh 
    
    -Crée le dossier de destination s'il n'existe pas.
    -Liste les archives disponibles pour selectionner une archive.
    -Décompresse l’archive dans un dossier temporaire .sh-toolbox/temp.
    -Trouve les fichiers modifiés après la dernière connexion de admin.
    -Cherche les fichiers chiffrés et utilise findkey pour retrouver la clé.
    -Stocke la clé dans le fichier archives ou dans un fichier KEY selon le type de la clé (s ou f).
    -Déchiffre les fichiers avec decipher, et garde le chemin relatif dans le dossier destination.
    -Demande confirmation avant d’écraser un fichier existant.
    
    usage:
        ./restore-archive.sh <out>
        
    **exemple :**
    
##  Etapes d'execution

    1- Initiailser l'environnement de travaille
        executer:
            ./init-toolbox.sh
            
    2- importer les archives dans sh-toolbox (il faut que les archives seront disponsibles dans l'environnement de travaille)
        executer:
            ./import-archive.sh client2-20250911-1002.tar.gz client1-20250901-1503.tar.gz
            
    3- Restaurer les fichiers chiffrees des archives dans le dossier 'out'
        executer:
            ./restore-archive.sh out

