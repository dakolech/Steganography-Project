#include "libraries.h"
#include "generate.h"
#include "decode.h"
#include "sendRecv.h"


#define BUFSIZE 10000
#define FILE_TO_SEND "plik2.pdf"

char *server = "127.0.0.1";	/* adres IP pętli zwrotnej */
char *protocol = "tcp";
short service_port = 1234;	/* port usługi daytime */

char bufor[BUFSIZE] = "--oo--";

int main ()
{
	struct sockaddr_in sck_addr;

	int sck;//, odp;

	printf ("Usługa %d na %s z serwera %s :\n", service_port, protocol, server);

	memset (&sck_addr, 0, sizeof sck_addr);
	sck_addr.sin_family = AF_INET;
	inet_aton (server, &sck_addr.sin_addr);
	sck_addr.sin_port = htons (service_port);

	if ((sck = socket (PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0) {
		perror ("Nie można utworzyć gniazdka");
		exit (EXIT_FAILURE);
	}

	if (connect (sck, (struct sockaddr*) &sck_addr, sizeof sck_addr) < 0) {
		perror ("Brak połączenia");
		exit (EXIT_FAILURE);
	}


    sendFileSizeAndFile(FILE_TO_SEND, sck); 

    recvFileSizeAndFile("plik4.pdf", sck); 


	
    char sentence[BUFSIZ];

    char id[4]="1234";
    char id2[4]="2468";
    char id3[4]="1357";
    char key[11]= "BEZLITOSNY2";
    char verb[10]= "LIKES";
    char verb2[10]= "LOVES";
    char verb3[10]= "HATES";
    //char buffer[BUFSIZ] = "";

    /*generateVerbSentence("IS", sentence);
    printf("%d\n", decodeVerbSentence(sentence));
    printf("%s\n", sentence);
    generateVerbSentence("ARE", sentence);
    printf("%s\n", sentence);
    generateVerbSentence("HAVE", sentence);
    printf("%s\n", sentence);
    generateVerbSentence("HAS", sentence);
    printf("%d\n", decodeVerbSentence(sentence));
    printf("%s\n", sentence);
    generateVerbSentence("WAS", sentence);
    printf("%s\n", sentence);
    generateVerbSentence("WERE", sentence);
    printf("%s\n", sentence);
    generateVerbSentence("HADNT", sentence);
    printf("%s\n", sentence);
    generateVerbSentence("HAD", sentence);
    printf("%s\n", sentence);
    printf("%d\n", decodeVerbSentence(sentence));*/



    generateNumberSentence(id, key, verb, sentence);
    printf("%s\n", sentence);
    write(sck, sentence, BUFSIZ);

    //sleep(2);

    generateNumberSentence(id2, key, verb2, sentence);
    printf("%s\n", sentence);
    write(sck, sentence, BUFSIZ);

    generateNumberSentence(id3, key, verb3, sentence);
    printf("%s\n", sentence);
    write(sck, sentence, BUFSIZ);

    //read (sck, buffer, BUFSIZ);

    /*
    //write(sck, msg, sizeof(msg));
    printf("%s\n", sentence);

    write(sck, sentence, sizeof(sentence));

    char buffer[100] = "";
    int rcvd;
    while ((rcvd = read (sck, buffer, sizeof(buffer))) > 0);
        //write (1, buffer, rcvd);

    printf("%s\n", buffer);


    generateSentence(id2, key, verb, sentence2);
    printf("%s\n", sentence2);
    write(sck, sentence2, sizeof(sentence2));
    
	//while ((odp = read (sck, bufor, BUFSIZE)) > 0)
	//	write (1, bufor, odp);

	*/
	close (sck);

	exit (EXIT_SUCCESS);
}
