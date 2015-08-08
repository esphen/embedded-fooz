#!/bin/bash

# The display logic and main executable of the app
# Dependencies: figlet, wiringPi and play (from VLC?)

# Fetch globals
source $(dirname $0)/variables.sh

# Fetch gpio logic
source $DIR/io.sh
source $DIR/functions.sh

source $DIR/lib/simple_curses.sh

# Fetch scores in file
get_scores

function check_scores_changed {

  # Play cheer if score changed
  if [ $RED_SCORE -gt $OLD_RED -o $BLUE_SCORE -gt $OLD_BLUE ]
  then
    # Discard stdout and redirect stderr to error_log
    play $DIR/lib/yay.ogg 2>&1 > /dev/null | error_log &

    set_old_scores
  fi
}

function set_old_scores {
    OLD_RED=$RED_SCORE
    OLD_BLUE=$BLUE_SCORE
}

# Preload scores
set_old_scores

# Continously checks io for input
function start_io_loop {
  while [[ 1 ]]
  do
    # TODO: Support two players
    check_input BLUE $BLUE_SCORE
  done
}

function main {
  debug_log "Redraw starting"
  get_scores

  check_scores_changed

  # TODO: append_command is very slow (2 blocking sec each)
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

