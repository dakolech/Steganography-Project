#pragma once

#define Success                        0

#define LogErrorBadVerbID             -1
#define LogErrorBadVerbPass           -2
#define LogErrorBadPass               -3

#define DirErrorCouldntOpen           -4

#define FileErrorCouldntDelete        -5

void error_handle(int status);
