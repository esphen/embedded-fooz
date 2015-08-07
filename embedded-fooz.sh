#!/bin/bash

# The display logic of the app
# Dependencies: figlet

# Fetch globals
source $(dirname $0)/variables.sh

# Fetch gpio logic
source $DIR/io.sh

source $DIR/lib/simple_curses.sh

# Fetch scores in file
get_scores

function check_scores {
  # Check if  scores changed
  if [ $RED_SCORE -gt $OLD_RED -o $BLUE_SCORE -gt $OLD_BLUE ]
  then
    play $DIR/lib/yay.ogg 1> /dev/null 2>> $ERRORLOG &
  fi
}

function set_old_scores {
    OLD_RED=$RED_SCORE
    OLD_BLUE=$BLUE_SCORE
}

# Preload scores
set_old_scores

main() {
  check_input
  get_scores

  check_scores
  set_old_scores

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

exit 0

