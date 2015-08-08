#!/bin/bash

# The display logic and main executable of the app
# Dependencies: figlet and play (from VLC?)

# Fetch globals
source $(dirname $0)/variables.sh

# Fetch gpio logic
source $DIR/io.sh
source $DIR/functions.sh

source $DIR/lib/simple_curses.sh

# Fetch scores in file
get_scores

function check_scores {
  # Check if  scores changed
  if [ $RED_SCORE -gt $OLD_RED -o $BLUE_SCORE -gt $OLD_BLUE ]
  then
    play $DIR/lib/yay.ogg 2>&1 > /dev/null | error_log &
  fi
}

function set_old_scores {
    OLD_RED=$RED_SCORE
    OLD_BLUE=$BLUE_SCORE
}

# Preload scores
set_old_scores

function main {
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

function redraw {
  POSX=0
  POSY=0
  tput cup 0 0 >> $BUFFER
  tput il $(tput lines) >> $BUFFER
  main >> $BUFFER 
  tput cup $(tput lines) $(tput cols) >> $BUFFER 
  refresh
}

function run {
  local LAST_TIME=$(get_timestamp)
  term_init
  init_chars

  # Run main loop
  while [[ 1 ]]
  do
    # Is user pressing button? Update score file if so
    check_input BLUE $BLUE_SCORE

    # Update screen sometimes
    if [[ $(($LAST_TIME + $REDRAW_TIME)) -lt $(get_timestamp) ]]
    then
      error_log "Test error"
      debug_log "Redraw starting"
      redraw
      LAST_TIME=$(get_timestamp)
      debug_log "Redraw complete"
    fi
  done
}

run

exit 0

