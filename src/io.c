#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include "io.h"
#include "constants.h"

int readPlayerScore(char *player) {

    int result = -1;
    char p[25];
    int i = 0;
    int c;

    // Get dirname
    char cwd[1024];
    if (getcwd(cwd, sizeof(cwd)) == NULL) {
        perror("getcwd() error");
    }

    strcat(cwd, "/score.txt");
    FILE *fp = fopen(cwd, "r");

    if (fp == NULL) {
        fprintf(stderr, "An error occured while opening score file: %s\n", cwd);
    } else {
        // Read file
        while ((c = getc(fp)) != EOF) {
            p[i++] = (char) c;
        }
        p[i] = '\0';
        fclose(fp);
    }

    // Search for player in file
    // Separate by token \n
    char * token;
    for ( token = strtok(p, "\n"); token != NULL; token = strtok(NULL, "\n") ) {
        char *substr = strstr(token, player);

        // If substr *player exists in token
        if (substr != NULL) {

            // Find index of =
            size_t index = strcspn(substr, "=") + 1;
            result = atoi(&substr[index]);
        }
    }

    if (result == -1) {
        fprintf(stderr, "Could not find score for %s\n", player);
        return 0;
    } else {
        return result;
    }
}

void get_figlet_digit(int score, char **output) {

    // Concat strings, run figlet and retrieve stream
    // strcat
    char command[23];
    sprintf(command, "%s %i", "/usr/bin/figlet ", score);
    FILE *stream = popen(command, "r");

    char buffer[1024];
    char *line_p;
    int i = 0;
    while ((line_p = fgets(buffer, sizeof(buffer), stream)) != '\0') {
        output[i] = malloc(NUMBER_WIDTH);
        strcpy(output[i++], line_p);
    }
    output[i] = '\0';
    pclose(stream);
}