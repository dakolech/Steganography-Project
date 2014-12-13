#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

void generateName(int n, char letter, char * file_name, char * name);
void generateNumberSentence(char * id, char * key_in, char * verb, char * sentence);
int generateVerbSentence(char * verb, char * sentence);
void randomInFile(char * fileName, char * output);
void randomAnimal(char * output);
void connectThreeWords(char * firstWord, char * secondWord, char * thirdWord, char * output);