
#ifndef VIGENERE_H
#define VIGENERE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void chiffrer_vigenere(char *texte, const char *cle);
void dechiffrer(char texte[], char cle[]) ;

char* lire_fichier( char *nom_fichier);
int ecrire_fichier( char *nom_fichier, char *contenu);

#endif 
