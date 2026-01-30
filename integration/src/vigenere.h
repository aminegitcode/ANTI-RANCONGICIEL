
#ifndef VIGENERE_H
#define VIGENERE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern const char alphabet[64];


void chiffrer_vigenere(char *texte, const char *cle);
void dechiffrer(unsigned char texte[], char cle[]) ;
char* findkey (char *txt_clair,char*  txt_chiff);
int position (char caractere,const char liste_caractere[],int longeur_liste);
int periode(char *chaine, int n);
char* lire_fichier( char *nom_fichier);
int ecrire_fichier( char *nom_fichier, char *contenu);

#endif 
