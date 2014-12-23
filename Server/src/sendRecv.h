#pragma once

int sendFileSizeAndFile(char * fileName, int sck);
int recvFileSizeAndFile(char * fileName, int sck);
int sendImage (char * id, int sck);
