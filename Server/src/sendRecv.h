#pragma once

int sendFileSizeAndFile(char * fileName, int sck);
int recvFileSizeAndFile(char * fileName, int sck);
int sendImages (char * id, int sck);
