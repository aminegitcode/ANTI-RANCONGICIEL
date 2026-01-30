

CC=gcc



OBJ=cipher decipher findkey

OBJ_CIPHER=cipher.o vigenere.o
OBJ_DECIPHER=decipher.o vigenere.o
OBJ_FINDKEY=findkey.o vigenere.o

all: $(OBJ)

cipher: $(OBJ_CIPHER)
	$(CC) $(OBJ_CIPHER) -o cipher
decipher: $(OBJ_DECIPHER)
	$(CC) $(OBJ_DECIPHER) -o decipher 
findkey: $(OBJ_FINDKEY)
	$(CC) $(OBJ_FINDKEY) -o findkey	
	
	
	
cipher.o: cipher.c vigenere.h
	$(CC) -c cipher.c 
decipher.o: decipher.c vigenere.h
	$(CC) -c decipher.c
findkey.o: findkey.c vigenere.h
	$(CC) -c findkey.c
vigenere.o: vigenere.c vigenere.h
	$(CC) -c vigenere.c
	
	
libvigenere.a: $(VIGENERE)
	ar rcs libvigenere.a vigenere.o


clean:
	rm -f *.o cipher decipher findkey

