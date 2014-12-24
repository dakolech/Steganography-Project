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
    write(socket, tempSentence, sizeof(tempSentence));

    read(socket, buffer, sizeof(buffer));
    if (decodeNumberSentence(buffer, MAINKEY, pass) != 2) {
        logStatus.status = LogErrorBadVerbPass;
        return logStatus;
    }

    if (checkUserLoginPass(logStatus.user_id, pass) == 0) {
        generateVerbSentence("IS", tempSentence);
        write(socket, tempSentence, sizeof(tempSentence));
    } else {
        generateVerbSentence("ARE", tempSentence);
        write(socket, tempSentence, sizeof(tempSentence));

        logStatus.status = LogErrorBadPass;
        return logStatus;
    }

    logStatus.status = Success;
    return logStatus;
}

void conn_send_all_images_to_user(int socket, char *id) {
    char imagesSentence[50];

    int howManyImagesToSend = countFilesInDirectory(id);
    if (howManyImagesToSend != Success) {
        error_handle(howManyImagesToSend);
        return;
    }

    //printf("%d Images to send\n", howManyImagesToSend);

    while (howManyImagesToSend > 0) {
        generateVerbSentence("HAVE", imagesSentence);
        //printf("%s\n", imagesSentence);
        write(socket, imagesSentence, sizeof(imagesSentence));
        int statusSendingFile = sendImage(id, socket);
        if (statusSendingFile != Success) {
            error_handle(statusSendingFile);
            break;
        }
        howManyImagesToSend--;
    }

    generateVerbSentence("HAS", imagesSentence);
    //printf("%s\n", imagesSentence);
    write(socket, imagesSentence, sizeof(imagesSentence));
}
