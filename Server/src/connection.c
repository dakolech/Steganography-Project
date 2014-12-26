#include "connection.h"

#include "decode.h"
#include "encode.h"
#include "libraries.h"
#include "users.h"
#include "sendRecv.h"
#include "errors.h"

#define MAINKEY "BEZLITOSNY2"

struct LogStatus conn_log_user(int socket) {
    struct LogStatus logStatus = {Success, ""};
    char buffer[100], pass[5] = "",
         tempSentence[50];

    read(socket, buffer, sizeof(buffer));
    if (decodeNumberSentence(buffer, MAINKEY, logStatus.user_id) != 1) {
        logStatus.status = LogErrorBadVerbID;
        return logStatus;
    }

    generateVerbSentence("USE", tempSentence);
    write(socket, tempSentence, strlen(tempSentence));

    strcpy(buffer, "");
    read(socket, buffer, sizeof(buffer));
    if (decodeNumberSentence(buffer, MAINKEY, pass) != 2) {
        logStatus.status = LogErrorBadVerbPass;
        return logStatus;
    }

    if (checkUserLoginPass(logStatus.user_id, pass) == Success) {
        generateVerbSentence("IS", tempSentence);
        write(socket, tempSentence, strlen(tempSentence));
    } else {
        generateVerbSentence("ARE", tempSentence);
        write(socket, tempSentence, strlen(tempSentence));

        logStatus.status = LogErrorBadPass;
        return logStatus;
    }

    logStatus.status = Success;
    return logStatus;
}

void conn_send_all_images_to_user(int socket, char *id) {
    char imagesSentence[50];

    int howManyImagesToSend = countFilesInDirectory(id);
    if (howManyImagesToSend == DirErrorCouldntOpen) {
        error_handle(howManyImagesToSend);
        return;
    }

    printf("\t%d Images to send\n", howManyImagesToSend);

    while (howManyImagesToSend > 0) {
        int statusSendingFile = sendImages(id, socket);
        if (statusSendingFile != Success) {
            error_handle(statusSendingFile);
            break;
        }
        howManyImagesToSend--;
    }

    generateVerbSentence("HAS", imagesSentence);
    write(socket, imagesSentence, strlen(imagesSentence));
}

void conn_generate_file_name_to_store(char *id, char *fileName) {
    char path[50] = "images/";
    strcat(path, id);
    strcat(path, "/");

    struct timeval unixTime;
    gettimeofday(&unixTime, NULL);

    char microseconds[7], seconds[20];
    sprintf(seconds,      "%lu", (unsigned long)unixTime.tv_sec);
    sprintf(microseconds, "%lu", (unsigned long)unixTime.tv_usec);

    strcat(path, seconds);
    strcat(path, ":");
    strcat(path, microseconds);
    strcat(path, ".png");

    strcpy(fileName, path);
}

int conn_receive_image_from_user(int socket, char *id) {
    char buffer[50], dest[5], fileName[50];

    read(socket, buffer, sizeof(buffer));
    int decodeStatus = decodeNumberSentence(buffer, MAINKEY, dest);
    if (decodeStatus != 3) {
        printf("\tZły czasownik w zapytaniu, status decode: %d\n", decodeStatus);
        printf("\tWadliwe zdanie to: %s\n", buffer);

        generateVerbSentence("HAD", buffer);
        write(socket, buffer, strlen(buffer));

        return InvalidImageDestination;
    }

    printf("\tOdczytano dest_id jako: %s\n", dest);
    generateVerbSentence("HADNT", buffer);
    write(socket, buffer, strlen(buffer));

    conn_generate_file_name_to_store(dest, fileName);
    printf("\tServer chce zapisać plik od klienta jako: %s\n", fileName);

    int status = recvFileSizeAndFile(fileName, socket);
    if (status == Success)
        return Success;
    else
        return status;
}

void conn_handle_event(int event, int socket, char *id) {
    switch (event) {
        case WAS:
            // klient chce zaległe obrazki
            printf("\tKlient chce odebrać zaległe obrazki!\n");
            conn_send_all_images_to_user(socket, id);
            break;
        case WERE:
            // klient chce wysłać obrazek
            printf("\tKlient chce wysłać obrazek!\n");
            conn_receive_image_from_user(socket, id);
            break;
    }
}

void conn_wait_for_requests(int socket, char *id) {
    char request[50];
    int running = 1;

    while (running) {
        read(socket, request, sizeof(request));

        int event = decodeVerbSentence(request);
        printf("\tRequest: %s\n", request);
        if (event != InvalidVerb)
            if (event != BELONG)
                conn_handle_event(event, socket, id);
            else
                running = 0;
        else
            error_handle(InvalidVerb);
    }
}
