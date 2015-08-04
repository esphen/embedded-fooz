#!/bin/bash

# The display logic of the app
# Dependencies: figlet

DIR=$(dirname $0)
FONT=$DIR/lib/doh.flf

# Fetch scores in file
source $DIR/score.txt
OLD_RED=$RED_SCORE
OLD_BLUE=$BLUE_SCORE

source $DIR/lib/simple_curses.sh

function check_scores {
  # Check if  scores changed
  if [ $RED_SCORE -gt $OLD_RED -o $BLUE_SCORE -gt $OLD_BLUE ]
  then
    play $DIR/lib/yay.ogg &> /dev/null &
  fi
}

function set_scores {
    OLD_RED=$RED_SCORE
    OLD_BLUE=$BLUE_SCORE
}

main() {
  # Fetch RED_SCORE and BLUE_SCORE from score file
  source $DIR/score.txt

  check_scores
  set_scores

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

