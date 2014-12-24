#include "libraries.h"
#include "connection.h"
#include "errors.h"

#define SERVER_PORT 1234
#define QUEUE_SIZE 5

void *client_loop2(void *arg) {
    int socket = *((int*)arg);

    printf("[BEGIN CLIENT LOOP] socket: %d\n", socket);
    struct LogStatus logStatus = conn_log_user(socket);
    if (logStatus.status == Success) {
        conn_send_all_images_to_user(socket, logStatus.user_id);

    } else {
        error_handle(logStatus.status);
    }

    sleep(1);
    close(socket);

    printf("[END CLIENT LOOP] socket: %d\n", socket);
    pthread_exit(NULL);
}

void *client_loop(void *arg) {
    char buffer[BUFSIZ] = "";
    char id[4] = "";
    char pass[4] = "";
    char destination[4] = "";
    int socket = *((int*) arg);
    char loginSentence[25] = "";
    char imagesSentence[25] = "";

    printf("[BEGIN CLIENT LOOP] socket: %d", socket);

    /*recvFileSizeAndFile("plik.png", socket);

    sendFileSizeAndFile("plik.png", socket);
    printf("Receive and Send file completed\n");*/

    /*read (socket, buffer, BUFSIZ);
    printf("%s 1\n", buffer);
    if (decodeNumberSentence(buffer, MAINKEY, id) != 1)
        endLoop(socket, "Incorrect verb in login");

    printf("%s\n", id);

    generateVerbSentence("USE", loginSentence);
    write(socket, loginSentence, sizeof(loginSentence));

    read (socket, buffer, BUFSIZ);
    printf("%s 2\n", buffer);
    if (decodeNumberSentence(buffer, MAINKEY, pass) != 2)
        endLoop(socket, "Incorrect verb in password");

    printf("%s\n", pass);

    if ( checkUserLoginPass(id, pass) == 0) {
        printf("Succes logging\n");

        generateVerbSentence("IS", loginSentence);
        write(socket, loginSentence, sizeof(loginSentence));

        int howManyImagesToSend = countFilesInDirectory(id);
        printf("%d Images to send\n", howManyImagesToSend);

        while (howManyImagesToSend > 0) {
            generateVerbSentence("HAVE", imagesSentence);
            printf("%s\n", imagesSentence);
            write(socket, imagesSentence, BUFSIZ);
            sendImage(id, socket);
            howManyImagesToSend--;
        }

        generateVerbSentence("HAS", imagesSentence);
        printf("%s\n", imagesSentence);
        write(socket, imagesSentence, BUFSIZ);



        read (socket, buffer, BUFSIZ);
        printf("%s 3\n", buffer);

        printf("%d\n", decodeNumberSentence(buffer, MAINKEY, destination));
        printf("%s\n", destination);

        read (socket, buffer, BUFSIZ);

    } else {
        generateVerbSentence("ARE", loginSentence);
        write(socket, loginSentence, BUFSIZ);
        endLoop(socket, "Login or password is incorrect");
    }

    sleep(1);
    close(socket);
    printf("[server] KONIEC wątku client_loop\n");
    pthread_exit(NULL);*/
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
        pthread_create(&id, NULL, client_loop2, &nClientSocket);
    }
    close(nSocket);
    return(0);
}
