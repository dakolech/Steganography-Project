#include "connection.h"

#include "decode.h"
#include "encode.h"
#include "libraries.h"
#include "errors.h"
#include "users.h"

#define MAINKEY "BEZLITOSNY2"

int conn_log_user(int socket) {
    char buffer[100] = "", id[5] = "", pass[5] = "",
         tempSentence[50] = "";

    read(socket, buffer, sizeof(buffer));
    if (decodeNumberSentence(buffer, MAINKEY, id) != 1)
        return LogErrorBadVerbID;

    generateVerbSentence("USE", tempSentence);
    write(socket, tempSentence, sizeof(tempSentence));

    read(socket, buffer, sizeof(buffer));
    if (decodeNumberSentence(buffer, MAINKEY, pass) != 2)
        return LogErrorBadVerbPass;

    if (checkUserLoginPass(id, pass) == 0) {
        generateVerbSentence("IS", tempSentence);
        write(socket, tempSentence, sizeof(tempSentence));
    } else {
        generateVerbSentence("ARE", tempSentence);
        write(socket, tempSentence, sizeof(tempSentence));

        return LogErrorBadPass;
    }
    return Success;
}
