#  Projet Gestionnaire d’archives — .sh-toolbox
## Scripts Bash — Gestion, Analyse & Historique d’archives `.tar.gz`


## Description du projet

    Ce projet propose un ensemble de scripts Bash permettant de gérer un environnement
    d’archives nommé .sh-toolbox.
    Il permet notamment de :
    • Initialiser un environnement de travail 
    • Ajouter et gérer des archives .gz
    • Maintenir un fichier archives contenant l’historique des archives stockées
    • Restaurer la cohérence entre le contenu du dossier et le fichier d’historique
    • Lister les archives et signaler les incohérences
    • Décompresser une archive et analyser son contenu :
        o Lire un fichier de logs
        o Identifier la dernière connexion réussie de admin
        o Afficher les fichiers modifiés avant/après cette connexion

## Structure du projet

    Après exécution de `init-toolbox.sh`, l’arborescence minimale est :

    ├── init-toolbox.sh # Initialise l'environnement
    └── .sh-toolbox
       └── archives # Conteneur des archives importées

    Contenu du dossier `.sh-toolbox` :
      Archives .gz stockées
      Fichier "archives" → historique des imports

### Exemple concret :

    .sh-toolbox/
    └── archives
    └── client1-20250411-1311.tar.gz


## Scripts disponibles

### 1`init-toolbox.sh` — Initialisation de l'environnement .sh-toolbox

Fonctionnalités :

    Vérifie qu’aucun argument n’est fourni
    Crée le dossier .sh-toolbox/ s’il n’existe pas
    Crée le fichier archives et initialise le compteur à 0
    Vérifie qu’aucun fichier n’est présent dans le dossier

Exemple d’exécution :

./init-toolbox.sh
    Initialisation de l'environnement de travail...
    Creation du dossier .sh-toolbox ...
    Creation reussi !
    Creation du fichier archives ...
    Creation reussi !
    Initialisation terminee avec succes !

Après exécution :
    .sh-toolbox/
    └── archives

### 2 import-archive.sh — Ajout d’archives .gz au dossier .sh-toolbox

Usage :

    ./import-archive.sh [-f] archive1.gz archive2.gz ...

Option
    -f	force le remplacement d’une archive existante

Fonctionnalités :

    Copie l’archive dans .sh-toolbox/
    Met à jour l’historique (archives)
    Ajoute ou modifie la date d’ajout
    Demande confirmation si un fichier existe déjà
    
Exemple d'exécution :

    ./import-archive.sh client1-20250411-1311.tar.gz
    
    Archive ' client1-20250411-1311.tar. ' copiée dans le dossier.
    Nouvelle archive ' client1-20250411-1311.tar. ' ajoutée dans
    l'historique.


### 3 ls-toolbox.sh — Affiche toutes les archives avec leur date et clé associée

Exemple :

    ./ls-archives.sh
    
    Archives :
    Nom: client1-20250411-1311.tar.gz
    Date: 250501-142233
    Cle:
    Nom: client2-20250411-1311.tar.gz
    Date: 250502-104512
    Cle:
    En cas d'incohérence :
    Avertissement : client2-20250411-1311.tar.gz existe dans .sh-
    toolbox mais n'est pas mentionné dans 'archives'

### 4 restore-toolbox.sh — Vérifie la cohérence entre le dossier .sh-toolbox/ et le fichier archives

Vérifie :
    Archives présentes dans archives mais manquantes dans .sh-toolbox
    Archives présentes dans le dossier mais absentes dans le fichier archives
    Propose suppression dans le dossier ou l'ajout dans archives ou ne rien faire
    

Exemple d'exécution :
    ./restore-toolbox.sh
    Le dossier .sh-toolbox existe
    Le fichier archives existe
    L'archive ' client2-20250411-1311.tar.gz ' existe dans
    'archives' mais pas dans '.sh-toolbox'
    Voulez-vous supprimer ' client2-20250411-1311.tar.gz ' du
    fichier 'archives' ? (1:oui / 0:non) 1
    suppression reussie
### 5 check-archive.sh — Décompresse une archive, lit les logs et analyse les fichiers modifiés

Fonctionnalités :

    Demande quelle archive analyser
    Décompresse l’archive dans .sh-toolbox/temp/
    Lit var/log/auth.log
    Trouve la dernière connexion réussie de l’utilisateur
    admin
    Affiche la liste des fichiers non modifiés qui portent le meme nom et ont la meme taille que chacun des fichiers modifiés

Exemple réel :

    Archives :
    1) client1-20250901-1503.tar.gz
    2) client4-20250901-1503.tar.gz
    3) client3-20250901-1503.tar.gz

    Selectionnez une archive (1/2.......) :
    1
    Voulez-vous parcourir et affficher le fichier Log (1:oui / 0:non)
    0
    La derniere connexion de l’utilisateur  'admin' :
    Jul 15 15:26:24

    Fichiers modifiés aprés la derniere connexion de admin :
    .sh-toolbox/temp/data/4563a97b58/exemple2.jpg
    .sh-toolbox/temp/data/24e7f60ec3/exemple1.txt

    Fichiers non modifiés après la dernière connexion de admin, en lecture seule, et qui n'appartiennent pas à admin :
    .sh-toolbox/temp/data/ccbf4b29f3/exemple1.txt
    .sh-toolbox/temp/data/ccbf4b29f3/exemple2.jpg
    
## Auteurs
Cylia Djafri	
Amine Djabri	
## Établissement
Université de Picardie — Jules Verne
