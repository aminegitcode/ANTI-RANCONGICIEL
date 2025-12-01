#include "vigenere.h"

int main(int argc, char *argv[]) {
    char *contenu_fichier;
    
    /* verifier les arguments */
    if (argc != 3) {
        printf("=== PROGRAMME DE CHIFFREMENT VIGENERE ===\n");
        printf("Utilisation: %s <clé> <fichier>\n", argv[0]);
        printf("\n");
        return 1;
    }
    
    /* recuperation des arguments */
    char *cle = argv[1];
    char *nom_fichier = argv[2];
    
    printf("Chiffrement du fichier: %s\n", nom_fichier);
    printf("Avec la clé: %s\n", cle);
    
    /* lecture du fichier*/
    contenu_fichier = lire_fichier(nom_fichier);
    if (contenu_fichier == NULL) {
        return 1;
    }
    
    /* application du chiffrement */
    printf("Application du chiffrement Vigenère\n");
    chiffrer_vigenere(contenu_fichier, cle);
    
    /* ecriture du resultat */
    /* Le fichier original est écrasé avec la version chiffrée */
    if (!ecrire_fichier(nom_fichier, contenu_fichier)) {
        free(contenu_fichier);
        return 1;
    }
    
    printf("Chiffrement terminé avec succès!\n");
    printf("Le fichier %s a été chiffré.\n", nom_fichier);
    
    /* liberation de la memoire */
    free(contenu_fichier);
    
    return 0;
}
