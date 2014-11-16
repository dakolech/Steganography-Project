#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <arpa/inet.h>
#include <time.h>
#include <pthread.h>

#define SERVER_PORT 1234
#define QUEUE_SIZE 5

void *client_loop(void *arg) {
    printf("[server] POCZĄTEK wątku client_loop\n");
    char buffer[1024] = "";
    int sck = *((int*) arg);
    int rcvd;

    int handle = 10;

    while ((rcvd = read (sck, buffer, sizeof(buffer))) > 0)
        //write (1, buffer, rcvd);

    printf("%s\n", buffer);

    //while(rcvd = recv(sck, buffer, 1024, 0))
	//    send(sck, buffer, rcvd, 0);
/*
    FILE *fp = fopen("send.txt", "r");
    int f_block_sz = 0;
    while ((f_block_sz = fread(buffer, sizeof(char), 1024, fp)) > 0) {
        if (send(sck, buffer, f_block_sz, 0) < 0) {
            printf("[server] ERROR: Failed to send file %s.\n", "send.txt");
            break;
        }
        bzero(buffer, 1024);
    }
    fclose(fp);*/
    close(sck);
    printf("[server] KONIEC wątku client_loop\n");
    pthread_exit(NULL);
}

int main(int argc, char* argv[]) {
    int nSocket, nClientSocket;
    int nBind, nListen;
    int nFoo = 1;
    int b;
    socklen_t nTmp;
    struct sockaddr_in stAddr, stClientAddr;
    /* address structure */
    memset(&stAddr, 0, sizeof(struct sockaddr));
    stAddr.sin_family = AF_INET;
    stAddr.sin_addr.s_addr = htonl(INADDR_ANY);
    stAddr.sin_port = htons(SERVER_PORT);
    /* create a socket */
    nSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (nSocket < 0) {
        fprintf(stderr, "%s: Can't create a socket.\n", argv[0]);
        exit(1);
    }
    setsockopt(nSocket, SOL_SOCKET, SO_REUSEADDR, (char*)&nFoo, sizeof(nFoo));
    /* bind a name to a socket */
    nBind = bind(nSocket, (struct sockaddr*)&stAddr, sizeof(struct sockaddr));
    if (nBind < 0) {
        fprintf(stderr, "%s: Can't bind a name to a socket.\n", argv[0]);
        exit(1);
    }
    /* specify queue size */
    nListen = listen(nSocket, QUEUE_SIZE);
    if (nListen < 0) {
        fprintf(stderr, "%s: Can't set queue size.\n", argv[0]);
    }

    while(1) {
        nClientSocket = accept(nSocket, (struct sockaddr*)&stClientAddr, &nTmp);
        printf("%s: [server] [connection from %s]\n", argv[0], inet_ntoa((struct in_addr)stClientAddr.sin_addr));
        if (nClientSocket < 0) {
            fprintf(stderr, "%s: Can't create a connection's socket.\n", argv[0]);
            exit(1);
        }

        pthread_t id;
        pthread_create(&id, NULL, client_loop, &nClientSocket);
    }
    close(nSocket);
    return(0);
}
