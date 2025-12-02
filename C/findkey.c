#include"vigenere.h"

int main( int argc, char *argv[]){
     if (argc != 3) {
        printf( "Usage: %s <fichier_clair> <fichier_chiffre>\n", argv[0]);
        return 1;
    }
    
    char *fichier_clair=argv[1];
    char *fichier_chiff=argv[2];
    
    char *contenu_clair= lire_fichier(fichier_clair); //Lire le contenu du fichier clair
    char *contenu_chiff=lire_fichier(fichier_chiff); //Lire le contenu du fichier chiffré
    
    //Trouver la clé
    char *cle=findkey(contenu_clair,contenu_chiff);
    
    
    printf("La clé est : %s",cle); //Afficher la cle sur la sortie standard
    int longueur_cle=strlen(cle);
    fprintf(stderr,"%d",longueur_cle);

    free(cle);
}
