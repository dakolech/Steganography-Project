#include "libraries.h"
#include "decode.h"
#include "errors.h"

int decodeNumberSentence(char * sentence, char * key, char * output) {
    // if sentence is empty
    if (strcmp(sentence, "") == 0)
        return -1;

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

   //printf("%s\n", verb);

   //printf("%d\n", first_letter_of_verb);
   //printf("%d\n", last_letter_of_verb);
   //printf("%s\n", output);

   return -1;
}

int decodeVerbSentence(char * sentence) {
    if (strlen(sentence) < 3)
        return InvalidVerb;

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

   if (strcmp(verb, "IS")    == 0) return IS;
   if (strcmp(verb, "ARE")   == 0) return ARE;
   if (strcmp(verb, "HAVE")  == 0) return HAVE;
   if (strcmp(verb, "HAS")   == 0) return HAS;
   if (strcmp(verb, "WAS")   == 0) return WAS;
   if (strcmp(verb, "WERE")  == 0) return WERE;
   if (strcmp(verb, "HADNT") == 0) return HADNT;
   if (strcmp(verb, "HAD")   == 0) return HAD;
   if (strcmp(verb, "USE")   == 0) return USE;

   return InvalidVerb;
}
