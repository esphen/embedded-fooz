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