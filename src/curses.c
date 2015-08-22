#include <stdlib.h>
#include <string.h>
#include "curses.h"
#include "io.h"
#include "constants.h"

void set_curses_config() {

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

void draw_window() {

  erase();

  int end_y = 0;
  int end_x = 0;

  getmaxyx(stdscr, end_y, end_x);

  // Draw logo
  int logo_height = 10;
  draw_box(end_x, logo_height, 0, 0, "OMS", NULL);

  char *blue_score = malloc(10);
  char *red_score = malloc(10);

  sprintf(blue_score, "%i", read_player_score("BLUE"));
  sprintf(red_score, "%i", read_player_score("RED"));

  int box_width = end_x / 2;
  draw_box(box_width, 20, 0, logo_height, blue_score, "BLUE");
  draw_box(box_width, 20, end_x / 2, logo_height, red_score, "RED");

  move(0, 0);
  refresh();
}

void draw_box(int width, int height, int x, int y, char *score, char *player) {

  WINDOW *draw_window = subwin(stdscr, height, width, y, x);

  int offset = 0;
  if (player != NULL) {
    offset = draw_header(width, player, draw_window);
  }

  // Get digit to draw in window
  char *asciiArt[NUMBER_HEIGHT];
  get_figlet_digit(score, asciiArt);

  int i = 0;
  char *string;
  while ((string = asciiArt[i++]) != '\0') {
    int xPos = (width / 2) - (int) (strlen(string) / 2);
    mvwaddstr(draw_window, i + offset + 1, xPos, string);
    free(string);
  }

  wborder(draw_window, '|', '|', '-', '-', '+', '+', '+', '+');
  touchwin(stdscr);
}

int draw_header(int width, const char *player, WINDOW *draw_window) {
  int offset = 2;
  short int color_pair = 1;
  start_color();

  if (strcmp(player, "RED") == 0) {
    init_pair(color_pair, COLOR_RED, COLOR_BLACK);
  } else if (strcmp(player, "BLUE") == 0) {
    init_pair(++color_pair, COLOR_BLUE, COLOR_BLACK);
  }

  wattron(draw_window, COLOR_PAIR(color_pair));
  mvwaddstr(draw_window, offset++, width / 2 - (int) (strlen(player) / 2), player);
  wattroff(draw_window, COLOR_PAIR(color_pair));

  mvwhline(draw_window, ++offset, 0, '-', width);
  return offset;
}

