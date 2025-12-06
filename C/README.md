
## Description du projet

Ce projet implémente un système de chiffrement/déchiffrement basé sur le chiffre de Vigenère adapté pour fonctionner avec l'encodage Base64.
Le projet comprend trois programmes principaux et une bibliothèque réutilisable.

### Principe de fonctionnement

    Le chiffrement s'effectue en trois étapes:
    1. Encodage Base64 du fichier original
    2. Chiffrement Vigenère sur l'alphabet Base64
    3. Décodage Base64 pour obtenir le fichier chiffré final

##  Structure des fichiers
    
    ├── vigenere.h          # pour les déclarations
    ├── vigenere.c          # Implémentation des fonctions
    ├── cipher.c            # Programme de chiffrement
    ├── decipher.c          # Programme de déchiffrement
    ├── findkey.c           # Programme pour trouver la clé
    ├── Makefile            # Script de compilation
    └── README.md           # Documentation (ce fichier)

## Compilation Encodage/Decodage
    - Commande `make`
    - Commande `base64` pour coder en base 64
    - Commande `base64 -- decode` pour decoder 
    
#Compilation
    make
    
##Encodage
    base64 exemple1.txt > exemple1(64).txt
    mv exemple1(64).txt exemple1.txt
     
    --- le cas d'une image ---
    base64 image.jpg > image.txt 
    
###decodage
    base64 --decode exemple1.txt > exemple1(dec).txt
    mv exemple1(dec).txt exemple1.txt
    
    --- le cas d'une image ---
    base64 --decode image.txt > image.png
    

## Utilisation des programmes
### 1. Programme `cipher` - Chiffrement
       - Lit un fichier encodé en Base64
       - Applique le chiffrement Vigenère
       - Écrase le fichier avec la version chiffrée

**Syntaxe:**
     ./cipher <clé> <fichier>

**Exemple complet:**

    ./cipher CleSAE2025 exemple1.txt
    Chiffrement du fichier: exemple1.txt
    Avec la clé: Q2xlU0FFMjAyNQ==
    Application du chiffrement Vigenère
    Chiffrement terminé avec succès!

### 2. Programme `decipher` - Déchiffrement
       - Déchiffrement d'un fichier déja chiffré (en base64)
       - Utilise la même clé

**Syntaxe:**
./decipher <clé> <fichier>

**Exemple complet:**

    ./decipher CleSAE2025 exemple1.txt
    Déchiffrement du fichier: exemple1.txt
    Avec la clé: Q2xlU0FFMjAyNQ==

    Déchiffrement...
    Déchiffrement terminé avec succès!

### 3. Programme `findkey` - Recherche de clé
      - Détermine la clé à partir d'un fichier clair et un fichier déja chiffré

**Syntaxe:**
./findkey <fichier_clair> <fichier_chiffré>

**Exemple:**
     ./findkey avant.txt apres.txt
    Détermination de la clé...
    Clé trouvée
    
    Longueur de la clé: 14
    La clé est : Q2xlU0FFMjAyNQ


## Bibliothèque statique (BONUS)

Le projet génère une bibliothèque statique `libvigenere.a` réutilisable

## Auteurs
CYLIA DJAFRI
AMINE DJABRI

## Établissement
Université de Picardie — Jules Verne
