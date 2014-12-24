#include "libraries.h"
#include "users.h"
#include "errors.h"

int compareIdOrPass(char * input, char * line);

int checkUserLoginPass(char * login, char * pass) {
	int len;
	FILE *fp;
	char line[25];

	fp = fopen("data/users.txt","r"); // read mode

	if( fp == NULL ) {
		perror("Error while opening the file.\n");
		exit(EXIT_FAILURE);
	}

	int count = 0;
	int searchPass = 0;
	while( fgets(line, 25,fp) ){
		count++;
		len = strlen(line);
		if( line[len-1] == '\n' )
			line[len-1] = 0;
		if (searchPass == 1 && strcmp(pass,line) == 0 && count%2 == 0) {
			fclose(fp);
			return 0;
		}
		else
			searchPass = 0;

		if (strcmp(login,line) == 0 && count%2)
			searchPass = 1;
	}

	fclose(fp);

	return -1;
}

int countFilesInDirectory(char * id) {
	int file_count = 0;
	DIR * dir;
	struct dirent * entry;

	char path[25] = "images/";
	strcat (path, id);

	if ((dir = opendir (path)) != NULL) {
		while ((entry = readdir(dir)) != NULL) {
		    if (entry->d_type == DT_REG) { /* If the entry is a regular file */
                file_count++;
		    }
		}
	} else {
        return DirErrorCouldntOpen;
    }

	closedir(dir);

	return file_count;
}
