#include <ncurses.h>

#ifndef CURSES_CURSES_H
#define CURSES_CURSES_H

void drawWindow();

void setCursesConfig();

void draw_box(int, int, int, int, char *, char *);

int drawHeader(int, const char *, WINDOW *);

#endif //CURSES_CURSES_H

