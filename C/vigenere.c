#include "vigenere.h"

void chiffrer_vigenere(char *texte, const char *cle) {
    const char *alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    int len = strlen(cle), j = 0; // recuperer la longueur de la cle 

    for (int i=0; texte[i]; i++) {
        char *p1 = strchr(alphabet, texte[i]);   // cherche le caractère texte[i] dans l’alphabet
        if(!p1) continue;//Ignore les caractères non Base64 

        char *p2 = strchr(alphabet, cle[j % len]);          // position clé
        int pos = (p1 - alphabet + (p2 - alphabet)) % 64;   // Vigenère mod 64

        texte[i] = alphabet[pos];                           // remplace dans le texte
        j++;
    }
}

char* lire_fichier(const char *nom_fichier) {
    FILE *fichier;
    char *contenu;
    long taille;
    
    /* Ouvrir le fichier en lecture binaire pour garantir la lecture du fichier sans transformation */
    fichier = fopen(nom_fichier, "rb");
    if (fichier == NULL) {
        fprintf(stderr, "Erreur: Impossible d'ouvrir %s\n", nom_fichier);
        return NULL;
    }
    
    /* Déterminer la taille du fichier pour allouer la memoire */
    fseek(fichier, 0, SEEK_END);
    taille = ftell(fichier);
    fseek(fichier, 0, SEEK_SET);
    
    /* Allouer la mémoire nécessaire */
    contenu = (char*)malloc(taille + 1);/*on ajoute un octet supplémentaire pour terminer la chaîne par '\0'*/
    if (contenu == NULL) {
        fprintf(stderr, "Erreur: Allocation mémoire échouée\n");
        fclose(fichier);
        return NULL;
    }
    
    /* Lire le fichier */
    fread(contenu, 1, taille, fichier);
    contenu[taille] = '\0';
    
    fclose(fichier);
    return contenu;
}
int ecrire_fichier(const char *nom_fichier, const char *contenu) {
    FILE *fichier;
    
    fichier = fopen(nom_fichier, "wb");
    if (fichier == NULL) {
        fprintf(stderr, "Erreur: Impossible de créer %s\n", nom_fichier);
        return 0;
    }
    
    fprintf(fichier, "%s", contenu);
    fclose(fichier);
    
    return 1;
}
