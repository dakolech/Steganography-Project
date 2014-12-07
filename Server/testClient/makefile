all: test

test: test.o generate.o
	gcc -Wall test.o generate.o -o test
	
test.o: test.c generate.h
	gcc -Wall -c test.c -o test.o

generate.o: generate.c generate.h
	gcc -Wall -c generate.c -o generate.o