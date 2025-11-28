#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Déchiffrement Vigenère sur tous les caractères
void vigenere_dechiffrer(char *texte, const char *cle, size_t taille) {
    int j = 0;
    int longueur_cle = strlen(cle);

    for (size_t i = 0; i < taille; i++) {
        texte[i] = (texte[i] - cle[j % longueur_cle] + 256) % 256;
        j++;
    }
}

// Lire tout le fichier
char* lire_fichier(const char* nom_fichier, size_t* taille) {
    FILE* f = fopen(nom_fichier, "rb");
    if (!f) {
        printf("Erreur : impossible d'ouvrir %s\n", nom_fichier);
        *taille = 0;
        return NULL;
    }

    fseek(f, 0, SEEK_END);
    *taille = ftell(f);
    fseek(f, 0, SEEK_SET);

    char* buffer = (char*)malloc(*taille);
    if (!buffer) {
        printf("Erreur : mémoire insuffisante\n");
        fclose(f);
        *taille = 0;
        return NULL;
    }

    fread(buffer, 1, *taille, f);
    fclose(f);

    return buffer;
}

// Écrire tout dans le même fichier (écrase le fichier original)
int ecrire_fichier(const char* nom_fichier, const char* buffer, size_t taille) {
    FILE* f = fopen(nom_fichier, "wb"); // wb écrase le fichier
    if (!f) {
        printf("Erreur : impossible de créer %s\n", nom_fichier);
        return 0;
    }

    fwrite(buffer, 1, taille, f);
    fclose(f);
    return 1;
}

// Programme principal
int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage : %s <clé> <fichier_chiffré>\n", argv[0]);
        return 1;
    }

    char* cle = argv[1];
    char* fichier = argv[2];

    size_t taille;
    char* buffer = lire_fichier(fichier, &taille);
    if (!buffer) return 1;

    vigenere_dechiffrer(buffer, cle, taille);

    if (ecrire_fichier(fichier, buffer, taille))
        printf("Déchiffrement terminé ! Le fichier a été écrasé.\n");

    free(buffer);
    return 0;
}
