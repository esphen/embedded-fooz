#!/bin/sh

# The display logic of the app
# Dependencies: figlet

DIR=$(dirname $0)
FONT=$DIR/lib/doh.flf

source $DIR/lib/simple_curses.sh


main() {
  # Fetch RED_SCORE and BLUE_SCORE from score file
  source $DIR/score.txt

  window "Red Score" "red" "50%"
  append_command "figlet -cf $FONT $RED_SCORE"
  endwin

  col_right
  move_up

  window "Blue Score" "blue" "50%"
  append_command "figlet -cf $FONT $BLUE_SCORE"
  endwin
}

# Start bashsimplecurses main loop
main_loop 0.5

