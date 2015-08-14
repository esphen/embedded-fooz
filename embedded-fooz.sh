#!/bin/bash

# The display logic and main executable of the app
# Dependencies: figlet, wiringPi and play (from SoX)

# Fetch globals
source $(dirname $0)/variables.sh
source $DIR/functions.sh
source $DIR/lib/simple_curses.sh

# Fetch gpio logic
source $DIR/io.sh

# Fetch scores in file
get_scores

# Continously checks io for input
function start_io_loop {
  while [[ 1 ]]
  do
    get_scores
    LAST_BLUE_READ=$(check_input BLUE $BLUE_SCORE $LAST_BLUE_READ $BLUE_PLAYER_PIN_IN)
    LAST_RED_READ=$(check_input RED $RED_SCORE $LAST_RED_READ $RED_PLAYER_PIN_IN)
  done
}

function main {
  debug_log "Redraw starting"
  get_scores

  # TODO: append_command is very slow (2 sec each invocation)
  # Not figlet's fault; bashsimplecurses' implementation?

  window "Red Score" "red" "50%"
  append_command "figlet -cf $FONT $RED_SCORE"
  endwin

  col_right
  move_up

  window "Blue Score" "blue" "50%"
  append_command "figlet -cf $FONT $BLUE_SCORE"
  endwin
  debug_log "Redraw complete"
}

# IO loop in background so it is not blocked
start_io_loop &
IO_PROCESS=$!
trap cleanup EXIT

# Start main loop and run every X sec
main_loop 0.5

exit 0

