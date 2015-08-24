# Generic and global functions

# Formats a string to the default log format
# $1 - The type of log this is (ERROR, LOG)
# $2 - The string to be logged
# $3 - An escape character squence of a colour
function format_log {
  echo "$3[ $1: $(date) ] $2 $NC"
}

# The main log function. Logs to logs folder,
# which is created if it does not exist.
# $1 - The type of log this is (ERROR, LOG)
# $2 - The logfile to write to
# $3 - An escape character squence of a colour
# $4 - The text to be written
function do_log {
  if [ ! -d $LOGDIR ]
  then
    mkdir -v $LOGDIR |& main_log
  fi

  echo -e $(format_log $1 "$4" $3) >> $2
}

# Reads from stdin if $1 is not provided.
# We want logging to support both invoking the
# functions directly and streams (like stderr)
function get_input {
  local IN

  if [ -n "$1" ]
  then
    IN="$1"
  else
    read IN
  fi

  echo $IN
}

function debug_log {
  local INPUT=$(get_input "$1")

  do_log DEBUG $DEBUG_LOGFILE "$NC" "$INPUT"
}

function main_log {
  local INPUT=$(get_input "$1")

  do_log LOG $DEBUG_LOGFILE "$NC" "$INPUT"
  do_log LOG $MAIN_LOGFILE "$NC" "$INPUT"
}

function error_log {
  local INPUT=$(get_input "$1")

  do_log ERROR $DEBUG_LOGFILE "$RED" "$INPUT"
  do_log ERROR $MAIN_LOGFILE "$RED" "$INPUT"
  do_log ERROR $ERROR_LOGFILE "$RED" "$INPUT"
}

# Play a cheerful tune!
# Also send error log to error_log and discard stout
function play_cheer {
  debug_log "Playing cheer"
  play -q $DIR/lib/yay.ogg 2> >(error_log) &
}

# Get scores from scorefile
function get_scores {
  source $SCOREFILE
}

# The function called when a player is declared the winner
# Changes application state to $STATE_WINNER for X seconds
# $1 - The player in question (BLUE, RED)
function enter_player_win_state {
  main_log "Game over! $1 player is the winner!"
  reset_scores

  APPLICATION_STATE=$STATE_WINNER

  debug_log "Sleeping for $WIN_STATE_SECONDS"
  sleep $WIN_STATE_SECONDS

  APPLICATION_STATE=$STATE_NORMAL

  main_log "Game reset, application state is $APPLICATION_STATE, play can now resume"
}

# $1 - The player in question (BLUE, RED)
# $2 - The score to set (1-7)
function set_score {
  sed -i $SCOREFILE -e "s/\($1.*\)[0-9]/\1$2/"
  get_scores
}

function reset_scores {
  main_log "Resetting scores"
  echo -e "BLUE_SCORE=0\nRED_SCORE=0" > $SCOREFILE
  debug_log < $SCOREFILE
}

# Cleanup other processes on exit
function cleanup {
  main_log "Cleanup happening - killing io process"
  kill $IO_PROCESS |& main_log

  reset_scores
  main_log "Cleanup completed"
}

