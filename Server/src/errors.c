#include "errors.h"

#include <stdio.h>

void error_handle(int status) {
    switch (status) {
        case LogErrorBadVerbID:
            fprintf(stderr, "Incorrect verb in ID\n");
            break;
        case LogErrorBadVerbPass:
            fprintf(stderr, "Incorrect verb in Pass\n");
            break;
        case LogErrorBadPass:
            fprintf(stderr, "Incorrect ID or password\n");
            break;
        case InvalidVerb:
            fprintf(stderr, "Invalid verb used in request\n");
            break;
    }
}
