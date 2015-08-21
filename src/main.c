#include <ncurses.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

const int NUMBER_WIDTH = 8;
const int NUMBER_HEIGHT = 7;

void get_figlet_digit(int, char **);

void drawWindow();

void setCursesConfig();

void drawScoreBox(int, int, int, int, char*);

int readPlayerScore(char*);

int drawHeader(int boxWidth, const char *player, WINDOW *drawWindow);

int main() {

  setCursesConfig();
  while(1) {
    drawWindow();
    sleep(0.5);
  }
  endwin();

  /*
  printf("Blue player: %i\n", readPlayerScore("BLUE"));
  printf("Red player: %i\n", readPlayerScore("RED"));
  printf("Teal player: %i\n", readPlayerScore("TEAL"));
  */

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

  erase();

  int endY = 0;
  int endX = 0;

  getmaxyx(stdscr, endY, endX);

  int boxWidth = endX / 2;

  drawScoreBox(boxWidth, 0, 0, readPlayerScore("BLUE"), "BLUE");

  drawScoreBox(boxWidth, endX / 2, 0, readPlayerScore("RED"), "RED");

  move(0, 0);
  refresh();
}

void drawScoreBox(int boxWidth, int x, int y, int score, char *player) {

  WINDOW* drawWindow = subwin(stdscr, 20, boxWidth, y, x);
  int offset = drawHeader(boxWidth, player, drawWindow);

  // Get digit to draw in window
  char *asciiArt[NUMBER_HEIGHT];
  get_figlet_digit(score, asciiArt);

  int i = 0;
  char *string;
  while ((string = asciiArt[i++]) != '\0') {
    int xPos = (boxWidth / 2) - (NUMBER_WIDTH / 2);
    mvwaddstr(drawWindow, i + offset + 3, xPos, string);
    free(string);
  }

  wborder(drawWindow, '|', '|', '-', '-', '+', '+', '+', '+');
  touchwin(stdscr);
}

int drawHeader(int boxWidth, const char *player, WINDOW *drawWindow) {
  int offset = 2;
  short int color_pair = 1;
  start_color();

  if (strcmp(player, "RED") == 0) {
    init_pair(color_pair, COLOR_RED, COLOR_BLACK);
  } else if (strcmp(player, "BLUE") == 0) {
    init_pair(++color_pair, COLOR_BLUE, COLOR_BLACK);
  }

  wattron(drawWindow, COLOR_PAIR(color_pair));
  mvwaddstr(drawWindow, offset++, boxWidth / 2 - (int) (strlen(player) / 2), player);
  wattroff(drawWindow, COLOR_PAIR(color_pair));

  mvwhline(drawWindow, ++offset, 0, '-', boxWidth);
  return offset;
}

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

