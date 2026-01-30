#include "vigenere.h"

const char alphabet[64] = {
    'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
    'Q','R','S','T','U','V','W','X','Y','Z',
    'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p',
    'q','r','s','t','u','v','w','x','y','z',
    '0','1','2','3','4','5','6','7','8','9',
    '+','/'
};
// Trouver la position d'un carctere dans une chaine 
int position (char caractere, const char liste_caractere[],int longeur_liste){
  for (int i=0; i<longeur_liste; i++){
    if (liste_caractere[i]==caractere){
      return i;
    }
  }
  return -1 ;
}


void chiffrer_vigenere(char *texte, const char *cle) {
    int longeur_cle = strlen(cle);
    int j=0;

    for (int i=0; texte[i]; i++) {
        int pos_carctere = position(texte[i],alphabet,64);  // Chercher le caractére texte[i] dans l’alphabet

        if (pos_carctere != -1){ //Assurer que le caractére existe
            // Chercher la position de la clé
            int pos_cle = position(cle[j%(longeur_cle)],alphabet,64);
            
            while(pos_cle == -1){ //Tant que le caractére n'existe pas on avance au suivant (dans la clé)
              j++;
              pos_cle = position(cle[j%(longeur_cle)],alphabet,64);
            }
            // Chiffrement 
            if(pos_cle!=-1){
              int pos = (pos_carctere + pos_cle ) % 64; // 
              texte[i] = alphabet[pos];
            }
            j++;
        }
    }
}




// Dechiffrement 
void dechiffrer(unsigned char texte[], char cle[]) {
    

    int longeur_cle = strlen(cle);
    int longueur_chaine=strlen(texte);
    int j = 0;

    for (int i = 0; i<longueur_chaine; i++) {
        // Chercher la position du caractére dans l'alphabet
        int pos_carctere = position(texte[i],alphabet,64);
        
        if (pos_carctere != -1){  //Assurer que le caractére existe

            // Chercher la position de la clé
            int pos_cle = position(cle[j%(longeur_cle)],alphabet,64);
            while(pos_cle == -1){ //Tant que le caractére n'existe pas on avance au suivant (dans la clé)
              j++;
              pos_cle = position(cle[j%(longeur_cle)],alphabet,64);
            }
            // Dechiffrement 
            if(pos_cle!=-1){
              int pos = (pos_carctere - pos_cle + 64) % 64; // On ajoute (+64) pour eviter le cas negatif (pos_cle > pos_caractere)
              texte[i] = alphabet[pos];
            }
            j++;
        }
    } 
}

char* findkey (char *txt_clair,char*  txt_chiff){
    int longueur=strlen(txt_clair); 
    char *cle=(char*)malloc(longueur); 
    char *cle_finale=(char*)malloc(longueur+1 ); 
  

    int j=0; //Indice pour la chaine clé
    
    
    for(int i=0;i<longueur;i++){
    //Trouver les positions des caracterés
      int pos_clair=position(txt_clair[i],alphabet,64); 
      int pos_chiff=position(txt_chiff[i],alphabet,64);
      
      //Verifier si les deux caracteres existent dans la liste alphabet base64
      if(pos_clair!=-1 && pos_chiff!=-1){
        int pos_cle=(pos_chiff - pos_clair +64 ) % 64; // Trouver l'indice du caractére de la clé
        cle[j]=alphabet[pos_cle];
        j++;
      }
    }

     
     // Trouver la periode
     int p=periode(cle,j);
     strncpy(cle_finale,cle,p);

     free(cle);
    
    return cle_finale;

}

//Calculer la période de la clé trouvé dans findkey
int periode(char *chaine, int n) {
    for (int p = 1; p <= n/2; p++) {
        int temp = 1;
        for (int i = 0; i < n-1; i++) {
            if (chaine[i] != chaine[i % p]) { // on compare avec la répétition
                temp = 0;
                break;
            }
        }
        if (temp) {
            return p; // période trouvée
        }
    }
    return n; // aucune période détectée, retourner longueur totale
}

// Lire un fichier
char* lire_fichier( char *nom_fichier) {
    FILE *fichier;
    char *contenu;
    long taille;
    
    /* Ouvrir le fichier en lecture */
    fichier = fopen(nom_fichier, "r");
    if (fichier == NULL) {
        fprintf(stderr, "Erreur: Impossible d'ouvrir %s\n", nom_fichier);
        return NULL;
    }
    
    /* Déterminer la taille du fichier pour allouer la memoire */
    fseek(fichier, 0, SEEK_END);
    taille = ftell(fichier);
    fseek(fichier, 0, SEEK_SET);
    
    /* Allouer la mémoire pour le contenu*/
    contenu = (char*)malloc(taille);
    if (contenu == NULL) {
        printf( "Erreur: Allocation mémoire échouée\n");
        fclose(fichier);
        return NULL;
    }
    
    /* Lire le fichier */
    fread(contenu, 1, taille, fichier);
    contenu[taille] = '\0';
    
    fclose(fichier);
    return contenu;
}

// Ecrire dans un fichier
int ecrire_fichier( char *nom_fichier,  char *contenu) {
    FILE *fichier;
    
    fichier = fopen(nom_fichier, "w");
    if (fichier == NULL) {
        printf("Erreur: Impossible de créer %s\n", nom_fichier);
        return 0;
    }
    
    fprintf(fichier, "%s", contenu);
    fclose(fichier);
    
    return 1;
}
