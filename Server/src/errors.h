#pragma once

#define Success                        0

#define LogErrorBadVerbID             -1
#define LogErrorBadVerbPass           -2
#define LogErrorBadPass               -3

#define DirErrorCouldntOpen           -4

#define FileErrorCouldntOpen          -5
#define FileErrorCouldntDelete        -6

#define InvalidVerb                   -7

#define InvalidImageDestination       -8

void error_handle(int status);
