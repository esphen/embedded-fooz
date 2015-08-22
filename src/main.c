#include <ncurses.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include "curses.h"

void termination_handler(int);

void setup_sigint_handler();

int main(int argc, int *argv[]) {
  int sleep_time = 1;

  setup_sigint_handler();

  set_curses_config();
  while(1) {
    draw_window();
    sleep(sleep_time);
  }

  // If it gets this far, something is wrong with main loop
  return EXIT_FAILURE;
}

void setup_sigint_handler() {
  struct sigaction new_action;

  new_action.sa_handler = termination_handler;
  new_action.sa_flags = 0;
  sigemptyset(&new_action.sa_mask);
  if (sigaction(SIGINT, &new_action, NULL) < 0) {
    perror("Error setting SIGINT handler");
  }
}

void termination_handler(int signum) {
  endwin();
  exit(EXIT_SUCCESS);
}

