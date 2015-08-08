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

# We want logging to support both invoking the
# functions directly and streams (like stderr)
# $1 - The type of log this is (ERROR, LOG)
# $2 - The logfile to write to
# $3 - An escape character squence of a colour
# $4 - The text to be written
function do_log {
  echo -e $(format_log $1 "$4" $3) >> $2
}

function get_input {
  if [ -n "$1" ]
  then
    IN="$1"
  else
    read IN
  fi
}
function debug_log {
  get_input "$1"

  do_log DEBUG $DEBUG_LOGFILE "$NC" "$IN"
}

function main_log {
  get_input "$1"

  do_log LOG $DEBUG_LOGFILE "$NC" "$IN"
  do_log LOG $MAIN_LOGFILE "$NC" "$IN"
}

function error_log {
  get_input "$1"

  do_log ERROR $DEBUG_LOGFILE "$RED" "$IN"
  do_log ERROR $MAIN_LOGFILE "$RED" "$IN"
  do_log ERROR $ERROR_LOGFILE "$RED" "$IN"
}

