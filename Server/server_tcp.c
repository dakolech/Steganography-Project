#include "libraries.h"
#include "generate.h"
#include "decode.h"
#include "sendRecv.h"
#include "users.h"

#define SERVER_PORT 1234
#define QUEUE_SIZE 5
#define MAINKEY "BEZLITOSNY2"

void endLoop(int sck, char * message) {
    close(sck);

    printf("%s\n", message);
    pthread_exit(NULL);
}

void *client_loop(void *arg) {
    //printf("[server] POCZĄTEK wątku client_loop\n");
    char buffer[BUFSIZ] = "";
    char id[4] = "";
    char pass[4] = "";
    char destination[4] = "";
    int sck = *((int*) arg);
    char loginSentence[25] = "";
    char imagesSentence[25] = "";

    read (sck, buffer, BUFSIZ);
    printf("%s 1\n", buffer);
    if (decodeNumberSentence(buffer, MAINKEY, id) != 1)
        endLoop(sck, "Incorrect verb in login");

    printf("%s\n", id);

    generateVerbSentence("USE", loginSentence);
    write(sck, loginSentence, BUFSIZ);

    read (sck, buffer, BUFSIZ);
    printf("%s 2\n", buffer);
    if (decodeNumberSentence(buffer, MAINKEY, pass) != 2)
        endLoop(sck, "Incorrect verb in password");

    printf("%s\n", pass);

    if ( checkUserLoginPass(id, pass) == 0) {
        printf("Succes logging\n");

        generateVerbSentence("IS", loginSentence);
        write(sck, loginSentence, BUFSIZ);

        /*int howManyImagesToSend = countFilesInDirectory(id);
        printf("%d Images to send\n", howManyImagesToSend);

        while (howManyImagesToSend > 0) {
            generateVerbSentence("HAVE", imagesSentence);
            printf("%s\n", imagesSentence);
            write(sck, imagesSentence, BUFSIZ);
            sendImage(id, sck);
            howManyImagesToSend--;
        }

        generateVerbSentence("HAS", imagesSentence);
        printf("%s\n", imagesSentence);
        write(sck, imagesSentence, BUFSIZ);



        read (sck, buffer, BUFSIZ);
        printf("%s 3\n", buffer);

        printf("%d\n", decodeNumberSentence(buffer, MAINKEY, destination));
        printf("%s\n", destination);

        read (sck, buffer, BUFSIZ);*/

    } else {
        generateVerbSentence("ARE", loginSentence);
        write(sck, loginSentence, BUFSIZ);
        endLoop(sck, "Login or password is incorrect");
    }





    //while ((rcvd = read (sck, buffer2, sizeof(buffer2))) > 0);

/*
    decodeNumberSentence(buffer, MAINKEY, id);*/

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
    //int b;
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
