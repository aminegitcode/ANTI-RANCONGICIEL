#include "vigenere.h"

int main(int argc, char *argv[]) {
    char *contenu_fichier;
    
    /* verifier les arguments */
    if (argc != 3) {
        printf("=== PROGRAMME DECHIFFREMENT VIGENERE ===\n");
        printf("Utilisation: %s <clé> <fichier>\n", argv[0]);
        printf("\n");
        return 1;
    }
    
    /* recuperation des arguments */
     char cle[] = argv[1];
    const char nom_fichier[] = argv[2];
    
    printf("Dechiffrement du fichier: %s\n", nom_fichier);
    printf("Avec la cle: %s\n", cle);
    
    /* lecture du fichier*/
    contenu_fichier = lire_fichier(nom_fichier);
    if (contenu_fichier == NULL) {
        return 1;
    }
    
    /*  dechiffrement */
    printf("Application du dechiffrement Vigenere...\n");
    dechiffrer(contenu_fichier, cle);
    
    /* ecriture du resultat */
    if (!ecrire_fichier(nom_fichier, contenu_fichier)) {
        free(contenu_fichier);
        return 1;
    }
    
    printf("Dechiffrement terminé avec succès!\n");
    
    
    /* liberation de la memoire */
    free(contenu_fichier);
    
    return 0;
}
