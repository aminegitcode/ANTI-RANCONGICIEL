#include"vigenere.h"

int main( int argc, int *argv[]){
     if (argc != 3) {
        printf( "Usage: %s <fichier_clair> <fichier_chiffre>\n", argv[0]);
        return 1;
    }
    
    char *contenu_clair= lire_fichier(argv[1]); //Lire le contenu du fichier clair
    char *contenu_chiff=lire_fichier(argv[2]); //Lire le contenu du fichier chiffré
    
    //Trouver la clé
    char *cle=findkey(contenu_clair,contenu_chiff);
    
    
    printf("La clé est : %s",cle); //Afficher la cle sur la sortie standard
    int longuer_cle=strlen(cle);
    fprintf(stderr,"%d",longeur_cle);

    free(cle);
}
