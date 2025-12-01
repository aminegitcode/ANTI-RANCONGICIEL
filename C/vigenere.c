#include "vigenere.h"

void chiffrer_vigenere(char *texte, const char *cle) {
    const char *alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    int len = strlen(cle), j = 0; // Récuperer la longueur de la cle 

    for (int i=0; texte[i]; i++) {
        char *p1 = strchr(alphabet, texte[i]);   // cherche le caractere texte[i] dans l’alphabet
        if(!p1) continue;//Ignore les caractères non Base64 

        char *p2 = strchr(alphabet, cle[j % len]);          // position clé
        int pos = (p1 - alphabet + (p2 - alphabet)) % 64;   // Vigenère mod 64

        texte[i] = alphabet[pos];                           // remplace dans le texte
        j++;
    }
}

// Trouver la position d'un carctere dans une chaine 
int position (char caractere, char liste_caractere[],int longeur_liste){
  for (int i=0; i<longeur_liste; i++){
    if (liste_caractere[i]==caractere){
      return i;
    }
  }
  return -1 ;
}


// Dechiffrement 
void dechiffrer(char texte[], char cle[]) {
    
    // Alphabet Base64 
    char alphabet[64] = {
        'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
        'Q','R','S','T','U','V','W','X','Y','Z',
        'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p',
        'q','r','s','t','u','v','w','x','y','z',
        '0','1','2','3','4','5','6','7','8','9',
        '+','/'
    };

    int longeur_cle = strlen(cle);
    int j = 0;

    for (int i = 0; texte[i]; i++) {
        // Chercher la position du caractére dans l'alphabet
        int pos_carctere = position(texte[i],alphabet,64);
        
        if (pos_carctere != -1){ 

            // Chercher la position de la clé
            int pos_cle = position(cle[j%longeur_cle],alphabet,64);

            // Dechiffrement modulo 64
            int pos = (pos_carctere - pos_cle + 64) % 64; // On ajoute (+64) pour eviter le cas negatif (pos_cle > pos_caractere)
            texte[i] = alphabet[pos];
            j++;
        }
    } 
}

char* findkey (char *txt_clair,char*  txt_chiff){
    // Alphabet Base64 
    char alphabet[64] = {
        'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
        'Q','R','S','T','U','V','W','X','Y','Z',
        'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p',
        'q','r','s','t','u','v','w','x','y','z',
        '0','1','2','3','4','5','6','7','8','9',
        '+','/'
    };
    int longeur=strlen(txt_clair); 
    char *cle=(char*)malloc(sizeof(longeur)); 
    int j=0;
    
    
    for(int i=0;i<longeur;i++){
    //Trouver les positions des caracterés
      int pos_clair=position(txt_clair[i],alphabet,64); 
      int pos_chiff=position(txt_chiff[i],alphabet,64);
      
      //Verifier si les deux caracteres existent dans la liste alphabet base64
      if(pos_clair!=-1 && pos_chiff!=-1){
        int pos_cle=(pos_chiff - pos_clair +64 ) % 64;
        cle[j]=alphabet[pos_cle];
        j++;
      }
    }
    
    return cle;

}



// Lire un fichier
char* lire_fichier( char *nom_fichier) {
    FILE *fichier;
    char *contenu;
    long taille;
    
    /* Ouvrir le fichier en lecture */
    fichier = fopen(nom_fichier, "rb");
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

// Ecrire dans un fichier
int ecrire_fichier( char *nom_fichier,  char *contenu) {
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
