

CC=gcc

VIGENERE=vigenere.o
VIGENERE_SRC=vigenere.c vigenere.h
OBJ1=cipher.o $(VIGENERE)
OBJ2=decipher.o $(VIGENERE)
OBJ3=findkey.o $(VIGENERE)


cipher: $(OBJ1)
	$(CC) $(OBJ1) -o cipher
decipher: $(OBJ2)
	$(CC) $(OBJ2) -o decipher 
findkey: $(OBJ3)
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

