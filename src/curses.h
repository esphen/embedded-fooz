#include <ncurses.h>

#ifndef CURSES_CURSES_H
#define CURSES_CURSES_H

void draw_window();

void set_curses_config();

void draw_box(int, int, int, int, char *, char *, char *);

int draw_header(int, const char *, WINDOW *);

#endif //CURSES_CURSES_H

