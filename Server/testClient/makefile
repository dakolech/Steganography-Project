all: test

test: test.o generate.o sendRecv.o
	gcc -Wall test.o generate.o sendRecv.o -o test
	
test.o: test.c generate.h sendRecv.h libraries.h
	gcc -Wall -c test.c -o test.o

generate.o: generate.c generate.h
	gcc -Wall -c generate.c -o generate.o

sendRecv.o: sendRecv.c sendRecv.h libraries.h
	gcc -Wall -c sendRecv.c -o sendRecv.o