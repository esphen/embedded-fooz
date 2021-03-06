#!/bin/bash

# The display logic and main executable of the app
# Dependencies: wiringPi and play (from SoX)

# Fetch globals
source $(dirname $0)/variables.sh
source $DIR/functions.sh

# Fetch gpio logic
source $DIR/io.sh

# Continously checks io for input
function start_io_loop {
  while [[ 1 ]]
  do
    get_scores
    LAST_BLUE_READ=$(check_input BLUE $BLUE_SCORE $LAST_BLUE_READ $BLUE_PLAYER_PIN_IN)
    LAST_RED_READ=$(check_input RED $RED_SCORE $LAST_RED_READ $RED_PLAYER_PIN_IN)
  done
}

# IO loop in background so it is not blocked by UI
start_io_loop &
IO_PROCESS=$!
trap cleanup EXIT

# Start main loop
$DIR/Curses 2> >(error_log)

exit 0

