#include "vigenere.h"
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    if (argc != 5 || strcmp(argv[3], "-o") != 0) {
        printf("Erreur d'usage: %s <fichier_clair> <fichier_chiffre> -o <fichier_cle>\n", argv[0]);
        return 1;
    }

    char *fichier_clair = argv[1];
    char *fichier_chiff = argv[2];
    char *fichier_cle = argv[4];

    char *contenu_clair = lire_fichier(fichier_clair);
    char *contenu_chiff = lire_fichier(fichier_chiff);

    if (contenu_clair == NULL) {
        printf("Erreur d'ouverture de %s\n", fichier_clair);
        return 1;
    }
    if (contenu_chiff == NULL) {
        printf("Erreur d'ouverture de %s\n", fichier_chiff);
        return 1;
    }

    printf("Détermination de la clé...\n");
    char *cle = findkey(contenu_clair, contenu_chiff);
    if (!cle) {
        printf("Erreur: impossible de trouver la clé\n");
        free(contenu_clair);
        free(contenu_chiff);
        return 1;
    }

    FILE *destination_cle = fopen(fichier_cle, "w");  // Écriture binaire pour éviter les problèmes de caractères non imprimables
    if (!destination_cle) {
        printf("Erreur: impossible de créer le fichier %s\n", fichier_cle);
        free(cle);
        free(contenu_clair);
        free(contenu_chiff);
        return 1;
    }

    fwrite(cle, sizeof(char), strlen(cle), destination_cle);
    fclose(destination_cle);
    printf("la clé est %s",cle);
    fprintf(stderr,"la lonngeur de la clé :%d",strlen(cle));


    free(cle);
    free(contenu_clair);
    free(contenu_chiff);
    return 0;
}

