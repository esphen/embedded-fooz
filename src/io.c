#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include "io.h"
#include "constants.h"

int read_player_score(char *player) {

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
  char *token;
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

void get_figlet_digit(char *score, char **output) {

  // Columns before line break
  int figlet_width = 100;

  // Concat strings, run figlet and retrieve stream
  char command[1024];
  sprintf(command, "%s %i %s", "/usr/bin/figlet -w", figlet_width, score);
  FILE *stream = popen(command, "r");

  if (stream == NULL) {
    fprintf(stderr, "Failed to open process %s\n", command);
    output = NULL;
  } else {
    char buffer[1024];
    char *line_p;
    int i = 0;
    while ((line_p = fgets(buffer, sizeof buffer, stream)) != '\0') {
      output[i] = malloc(1024);
      strcpy(output[i++], line_p);
    }
    output[i] = '\0';
    pclose(stream);
  }
}

