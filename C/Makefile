

CC=gcc

VIGENERE=vigenere.o
VIGENERE_SRC=vigenere.c vigenere.h
OBJ=cipher decipher findkey

OBJ_CIPHER=cipher.o $(VIGENERE)
OBJ_DECIPHER=decipher.o $(VIGENERE)
OBJ_FINDKEY=findkey.o $(VIGENERE)

all: $(OBJ)

cipher: $(OBJ_CIPHER)
	$(CC) $(OBJ1) -o cipher
decipher: $(OBJ_DECIPHER)
	$(CC) $(OBJ2) -o decipher 
findkey: $(OBJ_FINDKEY)
	$(CC) $(OBJ3) -o decipher 	
	
	
	
cipher.o: cipher.c vigenere.h
	$(CC) -c cipher.c 
decipher.o: decipher.c vigenere.h
	$(CC) -c decipher.c
findkey.o: findkey.c vigenere.h
	$(CC) -c findkey.c
$(VIGENERE): $(VIGENERE_SRC)
	$(CC) -c vigenere.c
	


clean:
	rm -f *.o cipher decipher findkey

