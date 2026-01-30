#include "vigenere.h"

int main(int argc, char *argv[]) {
    unsigned char *contenu_fichier;
    
    /* Verifier les arguments */
    if (argc != 3) {
        printf("Utilisation: %s <clé> <fichier>\n", argv[0]);
        printf("\n");
        return 1;
    }
    
    // Récuperation des arguments 
     char *cle = argv[1];
    char *nom_fichier = argv[2];
    
    printf("Déchiffrement du fichier: %s\n", nom_fichier);
    printf("Avec la clé: %s\n \n", cle);
    
    // Lecture du fichier
    contenu_fichier = lire_fichier(nom_fichier);
    if (contenu_fichier == NULL) {
        return 1;
    }
    
    /*  Dechiffrement */
    printf("Déchiffrement...\n");
    dechiffrer(contenu_fichier, cle);
    
    /* Ecriture du résultat */
    if (!ecrire_fichier(nom_fichier, contenu_fichier)) {
        free(contenu_fichier);
        return 1;
    }
    
    printf("Déchiffrement terminé avec succès!\n");
    
    
    /* Liberation de la mémoire */
    free(contenu_fichier);
    
    return 0;
}
