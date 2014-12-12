#include "libraries.h"
#include "decode.h"

int decodeNumberSentence(char * sentence, char * key, char * output) {

   int number_in_key = key[10] - '0';

   output[0] = sentence[number_in_key];

   int i = number_in_key;

   while (1) {
      i++;
      if (sentence[i] == ' ') break;
   }

   i += number_in_key;

   output[1] = sentence[i+1];

   while (1) {
      i++;
      if (sentence[i] == ' ') break;
   }

   int first_letter_of_verb = i+1;

   while (1) {
      i++;
      if (sentence[i] == ' ') break;
   }

   int last_letter_of_verb = i-1;

   i += number_in_key;

   output[2] = sentence[i+1];

   while (1) {
      i++;
      if (sentence[i] == ' ') break;
   }

   i += number_in_key;

   output[3] = sentence[i+1];

   int letter_in_output;
   for(letter_in_output = 0; letter_in_output<4; letter_in_output++) {
      int letter_in_key;
      for(letter_in_key = 0; letter_in_key<10; letter_in_key++) {
         if (output[letter_in_output] == key[letter_in_key]) {
            char dig = (char)(((int)'0')+letter_in_key);
            output[letter_in_output] = dig;
         }
      }
   }

   char verb[100] = "";

   //memcpy ( verb, sentence[first_letter_of_verb], last_letter_of_verb-first_letter_of_verb );

   strncpy(verb, &sentence[first_letter_of_verb], last_letter_of_verb-first_letter_of_verb+1);

   if (strcmp("LOVES", verb) == 0) 
      return 1;//login

   if (strcmp("LIKES", verb) == 0)
      return 2;//pass

   if (strcmp("HATES", verb) == 0)
      return 3;//destination

   printf("%s\n", verb);

   //printf("%d\n", first_letter_of_verb);
   //printf("%d\n", last_letter_of_verb);
   //printf("%s\n", output);

   return -1;
}

int decodeVerbSentence(char * sentence) {
   int i=0;
   while (1) {
      i++;
      if (sentence[i] == ' ') break;
   }
   int first_letter_of_verb = i+1;

   while (1) {
      i++;
      if (sentence[i] == ' ') break;
   }

   int last_letter_of_verb = i-1;

   char verb[25] = "";

   //printf("%d %d\n", first_letter_of_verb, last_letter_of_verb-first_letter_of_verb+1);

   strncpy(verb, &sentence[first_letter_of_verb], last_letter_of_verb-first_letter_of_verb+1);

   //printf("%s\n", verb);

   if (verb[0] == 'I') {

      return 1;

   } else if (verb[0] == 'A') {

      return 2;

   } else if (verb[2] == 'V') {
      
      return 3;
      
   } else if (verb[0] == 'H' && verb[2] == 'S') {
      
      return 4;
      
   } else if (verb[0] == 'W' && verb[2] == 'S') {
      
      return 5;
      
   } else if (verb[2] == 'R') {
      
      return 6;
      
   } else if (verb[3] == 'N') {
      
      return 7;
      
   } else if (verb[0] == 'H' && verb[2] == 'D') {
      
      return 8;
      
   } 

   return -1;

}