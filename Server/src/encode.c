#include "encode.h"
#include "decode.h"
#include "errors.h"

void generateName(int n, char letter, char * file_name, char * name) {

   //printf("Serching for %c in %d\n", letter, n);

   int zarodek, len;
   zarodek= time(NULL);
   srand(zarodek);
   char line[25];
   FILE *fp;

   fp = fopen(file_name,"r"); // read mode

   if( fp == NULL ) {

      perror("Error while opening the file.\n");
      exit(EXIT_FAILURE);
   }

   int count = 0, count2 = 0;
   while( fgets(line, 25,fp) ){
      if(line[n]==letter) {
         count++;
      }
   }
   count=rand()%count;

   fclose(fp);

   fp = fopen(file_name,"r");
   while( fgets(line, 25,fp) ){
      len = strlen(line);
      if( line[len-1] == '\n' )
         line[len-1] = 0;
      if(line[n]==letter) {
         count2++;
         if(count2==count){
            strcpy(name, line);
            strcat(name, "\0");
            fclose(fp);
            break;
         }
      }
   }
}


void generateNumberSentence(char * id, char * key_in, char * verb, char * sentence)
{
   //char * id = argv[1];
   int idArray[4];
   int i;
   for(i=0; i<4; i++)
      idArray[i] = id[i] - '0';


   char key[11];
   strncpy(key, key_in, 11);
   char letters[4];
   for(i=0; i<4; i++){
     letters[i]=key[idArray[i]];
   }

   //printf("%c\n",letters[1]);

   //printf("%c\n",key[10]);

   int n = key[10] - '0';
   //char letter = 'A';
   char file_name[50]="data/popular-both-first.txt";
   char file_name2[50]="data/popular-last.txt";
   char name1[25];
   char name2[25];
   char name3[25];
   char name4[25];



   generateName(n, letters[0], file_name, name1);
   //printf("%s\n",name1);
   generateName(n, letters[1], file_name2, name2);
   //printf("%s\n",name2);
   generateName(n, letters[2], file_name, name3);
   //printf("%s\n",name3);
   generateName(n, letters[3], file_name2, name4);
   //printf("%s\n",name4);

   char a[5][25];
   strcpy(a[0], "LIKES");
   strcpy(a[1], "HATES");
   strcpy(a[2], "LOVES");
   strcpy(a[3], "UNLIKES");
   strcpy(a[4], "ADMIRES");

   //printf("%s\n",a[rand()%5]);

   //printf("%s %s %s %s %s\n", name1, name2, verb, name3, name4);

   strcpy (sentence, name1);
   strcat (sentence, " ");
   strcat (sentence, name2);
   strcat (sentence, " ");
   strcat (sentence, verb);
   strcat (sentence, " ");
   strcat (sentence, name3);
   strcat (sentence, " ");
   strcat (sentence, name4);
   strcat (sentence, " ");
   strcat (sentence, "\n");

   char test[4] = "";

   decodeNumberSentence(sentence, key_in, test);
   if (strcmp(id,test) != 0)
      generateNumberSentence(id, key_in, verb, sentence);
}

void randomAnimal(char * output) {
   randomInFile("data/animals.txt", output);
}

void randomAdjective(char * output) {
   randomInFile("data/adjectives.txt", output);
}

void randomBodyPart(char * output) {
   randomInFile("data/bodyparts.txt", output);
}


void randomInFile(char * fileName, char * output) {

   int zarodek, len;
   zarodek= time(NULL);
   srand(zarodek);
   char line[25];
   FILE *fp;

   fp = fopen(fileName,"r"); // read mode

   if( fp == NULL ) {

      perror("Error while opening the file.\n");
      exit(EXIT_FAILURE);
   }

   int count = 0, count2 = 0;
   while( fgets(line, 25,fp) ){
      count++;
   }
   count=rand()%count;

   fclose(fp);

   fp = fopen(fileName,"r");
   while( fgets(line, 25,fp) ){
      len = strlen(line);
      if( line[len-1] == '\n' )
         line[len-1] = 0;
      count2++;
      if(count2==count){
         strcpy(output, line);
         fclose(fp);
         break;
      }
   }

}

void connectThreeWords(char * firstWord, char * secondWord, char * thirdWord, char * output) {
   strcpy (output, firstWord);
   strcat (output, " ");
   strcat (output, secondWord);
   strcat (output, " ");
   strcat (output, thirdWord);
   strcat (output, "\n");
}

int generateVerbSentence(char * verb, char * sentence) {

   char firstWord[25];
   char thirdWord[25];

    if (strcmp(verb, "USE") == 0) {
        char newVerb[5];
        randomAnimal(firstWord);
        strcpy(newVerb, verb);
        strcat (newVerb, "S");
        randomBodyPart(thirdWord);
        connectThreeWords(firstWord, newVerb, thirdWord, sentence);

        return USE;
    }
    if (strcmp(verb, "IS") == 0) {
        randomAnimal(firstWord);
        randomAdjective(thirdWord);
        connectThreeWords(firstWord, verb, thirdWord, sentence);

        return IS;
    }
    if (strcmp(verb, "ARE") == 0) {
        randomAnimal(firstWord);
        strcat (firstWord, "S");
        randomAdjective(thirdWord);
        connectThreeWords(firstWord, verb, thirdWord, sentence);

        return ARE;
    }
    if (strcmp(verb, "HAVE") == 0) {
        strcpy (firstWord, "I");
        randomBodyPart(thirdWord);
        connectThreeWords(firstWord, verb, thirdWord, sentence);

        return HAVE;
    }
    if (strcmp(verb, "HAS") == 0) {
        randomAnimal(firstWord);
        randomBodyPart(thirdWord);
        connectThreeWords(firstWord, verb, thirdWord, sentence);

        return HAS;
    }
    if (strcmp(verb, "WAS") == 0) {
        randomAnimal(firstWord);
        randomAdjective(thirdWord);
        connectThreeWords(firstWord, verb, thirdWord, sentence);

        return WAS;
    }
    if (strcmp(verb, "WERE") == 0) {
        randomAnimal(firstWord);
        strcat (firstWord, "S");
        randomAdjective(thirdWord);
        connectThreeWords(firstWord, verb, thirdWord, sentence);

        return WERE;
    }
    if (strcmp(verb, "HADNT") == 0) {
        randomAnimal(firstWord);
        randomBodyPart(thirdWord);
        connectThreeWords(firstWord, verb, thirdWord, sentence);

        return HADNT;
    }
    if (strcmp(verb, "HAD") == 0) {
        randomAnimal(firstWord);
        randomBodyPart(thirdWord);
        connectThreeWords(firstWord, verb, thirdWord, sentence);

        return HAD;
    }

    return InvalidVerb;
}

