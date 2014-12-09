#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <stdlib.h>
#include <unistd.h>
#include <strings.h>
#include <arpa/inet.h>
#include "generate.h"
#include <sys/sendfile.h>
#include <errno.h>
#include <string.h>
#include <sys/stat.h>
#include <fcntl.h>

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

    char file_size[256];
	struct stat file_stat;
	int sent_bytes = 0;
	int fd;
	int offset;
    int remain_data;

	fd = open(FILE_TO_SEND, O_RDONLY);
    if (fd == -1)
    {
            fprintf(stderr, "Error opening file --> %s", strerror(errno));

            exit(EXIT_FAILURE);
    }

    /* Get file stats */
    if (fstat(fd, &file_stat) < 0)
    {
            fprintf(stderr, "Error fstat --> %s", strerror(errno));

            exit(EXIT_FAILURE);
    }

    fprintf(stdout, "File Size: \n%d bytes\n", file_stat.st_size);

    sprintf(file_size, "%d", file_stat.st_size);

    write(sck, file_size, 256);

    char buffer[1024] = "";


    while (1) {
	    // Read data into buffer.  We may not have enough to fill up buffer, so we
	    // store how many bytes were actually read in bytes_read.
	    int bytes_read = read(fd, buffer, sizeof(buffer));
	    if (bytes_read == 0) // We're done reading from the file
	        break;

	    if (bytes_read < 0) {
	        // handle errors
	    }
	    

	    // You need a loop for the write, because not all of the data may be written
	    // in one call; write will return how many bytes were written. p keeps
	    // track of where in the buffer we are, while we decrement bytes_read
	    // to keep track of how many bytes are left to write.
	    void *p = buffer;
	    while (bytes_read > 0) {
	        int bytes_written = write(sck, p, bytes_read);
	        if (bytes_written <= 0) {
	            // handle errors
	        }
	        bytes_read -= bytes_written;
	        p += bytes_written;

	    }
	}
    /*
    offset = 0;
    remain_data = file_stat.st_size;
    /* Sending file data *//* 
    while (((sent_bytes = sendfile(sck, fd, &offset, BUFSIZ)) > 0) && (remain_data > 0))
    {
            fprintf(stdout, "1. Server sent %d bytes from file's data, offset is now : %d and remaining data = %d\n", sent_bytes, offset, remain_data);
            remain_data -= sent_bytes;
            fprintf(stdout, "2. Server sent %d bytes from file's data, offset is now : %d and remaining data = %d\n", sent_bytes, offset, remain_data);
    }
    */

    

	
    char sentence[1024];

    char id[4]="1234";
    char id2[4]="2468";
    char id3[4]="1357";
    char key[11]= "BEZLITOSNY3";
    char verb[10]= "LIKES";
    char verb2[10]= "LOVES";
    char verb3[10]= "HATES";


    generateSentence(id, key, verb, sentence);
    printf("%s\n", sentence);
    write(sck, sentence, 1024);

    //sleep(2);

    generateSentence(id2, key, verb2, sentence);
    printf("%s\n", sentence);
    write(sck, sentence, 1024);

    generateSentence(id3, key, verb3, sentence);
    printf("%s\n", sentence);
    write(sck, sentence, 1024);

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
