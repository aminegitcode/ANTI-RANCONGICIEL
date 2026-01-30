# 🛡️ Ransomware Recovery Toolkit — Guide d’utilisation

Ce README sert de **guide principal pour utiliser l’ensemble du projet**.  
Le projet combine des scripts Bash et des programmes en C pour **analyser, détecter et restaurer des fichiers chiffrés** après une attaque simulée par rançongiciel.

---

## 📌 Vue d’ensemble

Le projet est organisé en trois parties :

1. **Bash (.sh-toolbox)** – Gestion et analyse d’archives `.tar.gz`  
   - Initialisation, import, liste et vérification des archives  
   - Analyse des fichiers modifiés après une attaque  

2. **C (Vigenère/Base64)** – Chiffrement et déchiffrement  
   - Programmes `cipher`, `decipher`, `findkey`  
   - Bibliothèque réutilisable pour Vigenère  

3. **Intégration** – Combinaison des deux pour restaurer automatiquement les fichiers chiffrés  
   - Ergonomique et cohérent pour un usage simplifié  

Le scénario est **fictif et pédagogique**, destiné à la formation en cybersécurité.

---

## 🗂️ Structure du projet
```bash

├── .sh-toolbox/
│ └── archives/ # Conteneur des archives importées
│
├── bash/ # Scripts Bash
│ ├── init-toolbox.sh
│ ├── import-archive.sh
│ ├── ls-toolbox.sh
│ ├── restore-toolbox.sh
│ ├── check-archive.sh
│ └── restore-archive.sh
│
├── src/ # Programmes C
│ ├── decipher.c
│ ├── findkey.c
│ └── Makefile
│ 
└── README.md 
```

## ⚙️ Étapes pour utiliser le projet (Partie Intégration)

Dans cette section, nous utilisons **la partie Intégration** du projet pour restaurer les fichiers chiffrés.  
Le dossier `integration` contient tous les scripts et binaires nécessaires pour combiner Bash et C.

### 0️⃣ Préparer l’environnement

1. Cloner ou télécharger le projet sur votre machine.  
2. Se rendre dans le dossier d’intégration :

```bash
git clone https://github.com/aminegitcode/ANTI-RANCONGICIEL.git
cd integration
```
3. Les archives à restaurer sont disponibles dans le dossier Données/archives.
Vous pouvez passer directement le chemin complet de l’archive au moment de l’appel du script.
Ou bien copier les archives dans le dossier courant (integration) avant d’exécuter les scripts.
### 1️⃣ Initialiser l’environnement de travail

```bash
./init-toolbox.sh
```
  - Crée .sh-toolbox/
  - Vérifie et compile les binaires decipher et findkey
  - Supprime les fichiers objets temporaires
Exmple:
```bash
./init-toolbox.sh

Création du dossier .sh-toolbox ... Réussi
Compilation des binaires findkey et decipher ... Terminé
Nettoyage des fichiers objets
```
### 2️⃣ Importer des archives dans .sh-toolbox
```bash
./import-archive.sh [-f] <chemin/vers/archive1.tar.gz> <chemin/vers/archive2.tar.gz>
```
  - Copie les archives dans .sh-toolbox/
  - Met à jour le fichier archives
  - Demande confirmation si une archive existe déjà

    Exemple avec les archives du projet :
   ```bash
   ./import-archive.sh ../../data/archives/groupe1.tar.gz ../../data/archives/groupe2.tar.gz
   ```

   Vous pouvez aussi copier directement les fichiers .tar.gz dans le dossier courant et utiliser :
   ```bash
   ./import-archive.sh groupe1.tar.gz groupe2.tar.gz
   ```
### 3️⃣ Restaurer les fichiers chiffrés
```bash 
./restore-archive.sh <dossier_destination>
```
  - Crée le dossier destination si nécessaire
  - Liste les archives disponibles pour sélection
  - Décompresse l’archive temporairement
  - Identifie les fichiers modifiés après la dernière connexion de admin
  - Cherche les clés avec findkey si nécessaire
  - Déchiffre les fichiers avec decipher
  - Conserve l’arborescence relative dans le dossier destination
  - Demande confirmation avant d’écraser un fichier existant
Exemple :
```bash
./restore-archive.sh out
```
Tous les fichiers restaurés seront dans le dossier out/.

## 📖 Documentation détaillée par partie

Pour plus de détails sur chaque partie du projet, consultez les README spécifiques :

- [README Bash ](bash/readme.md) – Gestion et analyse des archives
- [README C ](src/README.md) – Chiffrement et déchiffrement
- [README Intégration](README_INTEGRATION.md) – Intégration finale et restauration automatique

Chaque README contient des instructions détaillées et des exemples pour chaque script ou programme.

## ⚠️ Avertissement
Ce projet est pédagogique et simplifié.
Ne pas utiliser comme solution réelle de réponse à incident
