#include "libraries.h"
#include "connection.h"
#include "errors.h"

#define SERVER_PORT 1234
#define QUEUE_SIZE 5

int nSocket;

void server_handle_SIGINT() {
    close(nSocket);
}

void *client_loop(void *arg) {
    int socket = *((int*)arg);

    printf("[BEGIN CLIENT LOOP] socket: %d\n", socket);
    struct LogStatus logStatus = conn_log_user(socket);
    if (logStatus.status == Success) {
        conn_wait_for_requests(socket, logStatus.user_id);
    } else {
        error_handle(logStatus.status);
    }

    sleep(1);
    close(socket);

    printf("[END CLIENT LOOP] socket: %d\n", socket);
    pthread_exit(NULL);
}

int main(int argc, char* argv[]) {
    int nClientSocket;
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

    signal(SIGINT, server_handle_SIGINT);
    while(1) {
        nClientSocket = accept(nSocket, (struct sockaddr*)&stClientAddr, &nTmp);
        if (nClientSocket < 0) {
            if (write(nSocket, "TESTING", 8) == -1) {
                break;
            } else {
                fprintf(stderr, "%s: Can't create a connection's socket.\n", argv[0]);
                exit(1);
            }
        }

        pthread_t id;
        pthread_create(&id, NULL, client_loop, &nClientSocket);
    }

    return 0;
}
