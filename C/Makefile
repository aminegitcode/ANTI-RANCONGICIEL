# ===================================================
# MAKEFILE pour le projet de chiffrement Vigenère
# ===================================================
# Ce fichier permet de compiler automatiquement tous
# les programmes avec la commande 'make'
# ===================================================

# VARIABLES DE CONFIGURATION
# Le compilateur C à utiliser
CC = gcc

# Les options de compilation
# -Wall : affiche tous les avertissements
# -Wextra : avertissements supplémentaires
# -g : informations de débogage
CFLAGS = -Wall -Wextra -g

# Commande pour créer une bibliothèque statique
AR = ar
ARFLAGS = rcs

# DEFINITION DES CIBLES
# Les programmes à créer
PROGRAMMES = cipher decipher findkey

# La bibliothèque statique
BIBLIOTHEQUE = libvigenere.a

# Les fichiers objets nécessaires
OBJETS = vigenere.o

# ===================================================
# REGLES DE COMPILATION
# ===================================================

# Règle par défaut: compile tout
all: $(PROGRAMMES)
	@echo "==================================="
	@echo "Compilation terminée avec succès!"
	@echo "Programmes disponibles:"
	@echo "  - ./cipher    : pour chiffrer"
	@echo "  - ./decipher  : pour déchiffrer"
	@echo "  - ./findkey   : pour trouver la clé"
	@echo "==================================="

# Compilation de la bibliothèque statique
$(BIBLIOTHEQUE): $(OBJETS)
	@echo "Création de la bibliothèque statique..."
	$(AR) $(ARFLAGS) $(BIBLIOTHEQUE) $(OBJETS)
	@echo "Bibliothèque $(BIBLIOTHEQUE) créée"

# Compilation du module vigenere
vigenere.o: vigenere.c vigenere.h
	@echo "Compilation du module vigenere..."
	$(CC) $(CFLAGS) -c vigenere.c -o vigenere.o

# Compilation du programme cipher
cipher: cipher.c $(BIBLIOTHEQUE)
	@echo "Compilation du programme cipher..."
	$(CC) $(CFLAGS) cipher.c -L. -lvigenere -o cipher

# Compilation du programme decipher
decipher: decipher.c $(BIBLIOTHEQUE)
	@echo "Compilation du programme decipher..."
	$(CC) $(CFLAGS) decipher.c -L. -lvigenere -o decipher

# Compilation du programme findkey
findkey: findkey.c $(BIBLIOTHEQUE)
	@echo "Compilation du programme findkey..."
	$(CC) $(CFLAGS) findkey.c -L. -lvigenere -o findkey

# ===================================================
# REGLES UTILITAIRES
# ===================================================

# Nettoyer les fichiers temporaires
clean:
	@echo "Nettoyage des fichiers temporaires..."
	rm -f *.o *~ *.bak
	@echo "Nettoyage terminé"

# Nettoyer tout (y compris les exécutables)
distclean: clean
	@echo "Suppression des exécutables et bibliothèques..."
	rm -f $(PROGRAMMES) $(BIBLIOTHEQUE)
	@echo "Nettoyage complet terminé"

# Créer uniquement la bibliothèque
lib: $(BIBLIOTHEQUE)
	@echo "Bibliothèque prête à l'emploi!"

# Aide
help:
	@echo "==================================="
	@echo "AIDE - Utilisation du Makefile"
	@echo "==================================="
	@echo "Commandes disponibles:"
	@echo "  make         : compile tous les programmes"
	@echo "  make cipher  : compile uniquement cipher"
	@echo "  make decipher: compile uniquement decipher"
	@echo "  make findkey : compile uniquement findkey"
	@echo "  make lib     : crée la bibliothèque statique"
	@echo "  make clean   : supprime les fichiers temporaires"
	@echo "  make distclean: supprime tout"
	@echo "  make help    : affiche cette aide"
	@echo "==================================="

# Indiquer que ces cibles ne sont pas des fichiers
.PHONY: all clean distclean lib help
