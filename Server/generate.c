#include "generate.h"

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
            break;
         }
      }
   }
}


void generateSentence(char * id, char * key_in, char * verb, char * sentence)
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
   strcat (sentence, "\0");

}