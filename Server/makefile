all: server_tcp

server_tcp: server_tcp.o decode.o sendRecv.o
	gcc -Wall server_tcp.o decode.o sendRecv.o -o server_tcp -lpthread
	
server_tcp.o: server_tcp.c decode.h libraries.h sendRecv.h
	gcc -Wall -c server_tcp.c -o server_tcp.o -lpthread

decode.o: decode.c decode.h libraries.h
	gcc -Wall -c decode.c -o decode.o

sendRecv.o: sendRecv.c sendRecv.h libraries.h
	gcc -Wall -c sendRecv.c -o sendRecv.o