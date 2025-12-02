#include"vigenere.h"

int main( int argc, char *argv[]){
     if (argc != 3) {
        printf( "Erreur d'usage: %s <fichier_clair> <fichier_chiffre>\n", argv[0]);
        return 1;
    }
    
    char *fichier_clair=argv[1];
    char *fichier_chiff=argv[2];
    
    char *contenu_clair= lire_fichier(fichier_clair); //Lire le contenu du fichier clair
    char *contenu_chiff=lire_fichier(fichier_chiff); //Lire le contenu du fichier chiffré
    
    if(contenu_clair== NULL){
      printf("Erreur d'ouverture de %s",fichier_clair);
      return 1;
    }
    if(contenu_chiff==NULL){
      printf("Erreur d'ouverture de %s",fichier_chiff);
      return 1;
    }
    
    printf("Détermination de la clé...\n");
    //Trouver la clé
    char *cle=findkey(contenu_clair,contenu_chiff);
    printf("Clé trouvée \n");
    
    
    int longueur_cle=strlen(cle);
    printf("\nLa clé est : %s",cle); //Afficher la cle sur la sortie standard
    fprintf(stderr,"Longueur de la clé: %d \n",longueur_cle);
    
    free(cle);
    free(contenu_clair);
    free(contenu_chiff);
    return 0;
}
