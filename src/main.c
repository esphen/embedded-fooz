#include <ncurses.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

const int NUMBER_WIDTH = 8;
const int NUMBER_HEIGHT = 7;

void get_figlet_digit(int, char **);

void drawWindow();

void setCursesConfig();

void drawScoreBox(int, int, int, int);

int readPlayerScore(char*);

int main() {

  setCursesConfig();
  while(1) {
    drawWindow();
    sleep(1);
  }
  endwin();
  /*printf("Blue player: %i\n", readPlayerScore("BLUE"));
  printf("Red player: %i\n", readPlayerScore("RED"));
  printf("Teal player: %i\n", readPlayerScore("TEAL"));*/

  // If it gets this far, something is wrong with main loop
  return EXIT_FAILURE;
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

void setCursesConfig() {

  // Init
  initscr();

  // Make characters typed available to the program
  cbreak();

  // Do not echo user typed characters
  noecho();

  // Disable return key newline feature
  nonl();

  // Properly flush screen on interrupt
  intrflush(stdscr, TRUE);

  // Capture keys like KEY_LEFT
  keypad(stdscr, TRUE);
}

void drawWindow() {

  int endY = 0;
  int endX = 0;

  getmaxyx(stdscr, endY, endX);

  int boxWidth = endX / 2;

  drawScoreBox(boxWidth, 0, 0, readPlayerScore("BLUE"));

  drawScoreBox(boxWidth, endX / 2, 0, readPlayerScore("RED"));
}

void drawScoreBox(int boxWidth, int x, int y, int score) {

  WINDOW* drawWindow = subwin(stdscr, 20, boxWidth, y, x);

  // Get digit to draw in window
  char *asciiArt[NUMBER_HEIGHT];
  get_figlet_digit(score, asciiArt);

  int i = 0;
  char *string;
  while ((string = asciiArt[i++]) != '\0') {
    int xPos = (boxWidth / 2) - (NUMBER_WIDTH / 2);
    wmove(drawWindow, i, xPos);

    waddstr(drawWindow, string);
    free(string);
  }

  wborder(drawWindow, '|', '|', '-', '-', '+', '+', '+', '+');
  touchwin(stdscr);
  move(0, 0);
  refresh();
}

int readPlayerScore(char * player) {
  int result = -1;
  char p[20];
  int i = 0;
  int c;

  // Get dirname
  char cwd[1024];
  if (getcwd(cwd, sizeof(cwd)) == NULL)
      perror("getcwd() error");
  strcat(cwd, "/score.txt");

  FILE *fp = fopen(cwd, "r");

  if (fp == NULL) {
    printf("An error occured while opening score file: %s\n", cwd);
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
  char * t1;
  for ( t1 = strtok(p, "\n"); t1 != NULL; t1 = strtok(NULL, " ") ) {
    char *substr = strstr(t1, player);

    // If substr *player exists in token
    if (substr != NULL) {

      // Find index of =
      size_t index = strcspn(substr, "=") + 1;
      result = atoi(&substr[index]);
    }
  }

  return result;
}

