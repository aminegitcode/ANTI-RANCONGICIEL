
#ifndef VIGENERE_H
#define VIGENERE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


/* Prototypes des fonctions principales */
void chiffrer_vigenere(char *texte, const char *cle);
void dechiffrer(char texte[], char cle[]) ;

/* Fonctions utilitaires pour la gestion des fichiers */
char* lire_fichier( char *nom_fichier);
int ecrire_fichier( char *nom_fichier, char *contenu);

#endif 
