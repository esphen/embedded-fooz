#include <ncurses.h>

#ifndef CURSES_CURSES_H
#define CURSES_CURSES_H

void drawWindow();

void setCursesConfig();

void drawScoreBox(int, int, int, int, char*);

int drawHeader(int boxWidth, const char *player, WINDOW *drawWindow);

#endif //CURSES_CURSES_H
