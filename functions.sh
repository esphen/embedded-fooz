# Generic functions

function get_timestamp {
  echo $(date +%s)
}

# Formats a string to the default log format
# $1 - The type of log this is (ERROR, LOG)
# $2 - The string to be logged
# $3 - An escape character squence of a colour
function format_log {
  echo "$3[ $1: $(date) ] $2 $NC"
}

# $1 - The type of log this is (ERROR, LOG)
# $2 - The logfile to write to
# $3 - An escape character squence of a colour
# $4 - The text to be written
function do_log {
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

# Cleanup other processes on exit
function cleanup {
  main_log "Cleanup happening - killing io process"
  kill $IO_PROCESS |& main_log

  echo -e "BLUE_SCORE=0\nRED_SCORE=0" > $DIR/score.txt
}

