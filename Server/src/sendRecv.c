#include "libraries.h"
#include "sendRecv.h"
#include "errors.h"
#include "encode.h"

int sendFileSizeAndFile(char * fileName, int sck) {

	char file_size[32];
	struct stat file_stat;
	int fd;

	fd = open(fileName, O_RDONLY);
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

    printf("\tFile Size: %jd bytes\n", file_stat.st_size);

    sprintf(file_size, "%jd\n", file_stat.st_size);

    write(sck, file_size, strlen(file_size));

    char buffer[BUFSIZ] = "";

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
    close(fd);
	return 0;
}

int recvFileSizeAndFile(char * fileName, int sck) {

	char buffer[BUFSIZ] = "";

	int file_size;

    read(sck, buffer, BUFSIZ);
    file_size = atoi(buffer);
    fprintf(stdout, "\nFile size : %d bytes.\n", file_size);

    ssize_t len;
    FILE *received_file;
    int remain_data = 0;


    received_file = fopen(fileName, "w");
    if (received_file == NULL) {
        fprintf(stderr, "Failed to open file foo --> %s\n", strerror(errno));
        return FileErrorCouldntOpen;
    }

    remain_data = file_size;

    while ((remain_data > 0) && ((len = recv(sck, buffer, BUFSIZ, 0)) > 0))
    {
            fwrite(buffer, sizeof(char), len, received_file);
            remain_data -= len;
            //fprintf(stdout, "Receive %jd bytes and we hope :- %d bytes\n", len, remain_data);
    }
    fclose(received_file);

    return Success;

}

int sendImages (char * id, int socket) {
    DIR *dir;
    struct dirent *ent;
    char path[50] = "images/", fileName[50], tempSentence[50];

    strcat (path, id);
    strcat (path, "/");

    if ((dir = opendir (path)) != NULL) {
        /* print all the files and directories within directory */
        while ((ent = readdir (dir)) != NULL) {
            if (ent->d_type == DT_REG) {
                generateVerbSentence("HAVE", tempSentence);
                write(socket, tempSentence, strlen(tempSentence));

                strcpy(fileName, path);
                strcat(fileName, ent->d_name);
                printf ("\tFile: %s\n", fileName);
                sendFileSizeAndFile(fileName, socket);
                if (remove(fileName) != 0)
                    return FileErrorCouldntDelete;
            }
        }
        closedir (dir);
    } else {
        return DirErrorCouldntOpen;
    }
    return Success;
}
