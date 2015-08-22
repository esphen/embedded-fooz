#include <stdlib.h>
#include <string.h>
#include "curses.h"
#include "io.h"
#include "constants.h"

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

  // Draw logo
  int logo_height = 10;
  draw_box(endX, logo_height, 0, 0, "OMS", NULL);

  int boxWidth = endX / 2;
  char *blueScore = malloc(10);
  char *redScore = malloc(10);

  sprintf(blueScore, "%i", readPlayerScore("BLUE"));
  sprintf(redScore, "%i", readPlayerScore("RED"));

  draw_box(boxWidth, 20, 0, logo_height, blueScore, "BLUE");

  draw_box(boxWidth, 20, endX / 2, logo_height, redScore, "RED");

  move(0, 0);
  refresh();
}

void draw_box(int boxWidth, int height, int x, int y, char *score, char *player) {

  WINDOW* drawWindow = subwin(stdscr, height, boxWidth, y, x);

  int offset = 0;
  if (player != NULL) {
    offset = drawHeader(boxWidth, player, drawWindow);
  }

  // Get digit to draw in window
  char *asciiArt[NUMBER_HEIGHT];
  get_figlet_digit(score, asciiArt);

  int i = 0;
  char *string;
  while ((string = asciiArt[i++]) != '\0') {
    int xPos = (boxWidth / 2) - (int) (strlen(string) / 2);
    mvwaddstr(drawWindow, i + offset + 1, xPos, string);
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

