all: test

test: test.o decode.o generate.o sendRecv.o
	gcc -Wall test.o decode.o generate.o sendRecv.o -o test
	
test.o: test.c decode.h generate.h sendRecv.h libraries.h
	gcc -Wall -c test.c -o test.o

decode.o: decode.c decode.h libraries.h
	gcc -Wall -c decode.c -o decode.o

generate.o: generate.c generate.h
	gcc -Wall -c generate.c -o generate.o

sendRecv.o: sendRecv.c sendRecv.h libraries.h
	gcc -Wall -c sendRecv.c -o sendRecv.o