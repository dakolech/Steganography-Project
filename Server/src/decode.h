#pragma once

#define USE             1
#define IS              2
#define ARE             3
#define HAVE            4
#define HAS             5
#define WAS             6
#define WERE            7
#define HADNT           8
#define HAD             9

int decodeNumberSentence(char * sentence, char * key, char * output);
int decodeVerbSentence(char * sentence);
