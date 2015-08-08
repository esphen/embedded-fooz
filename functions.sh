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
# $4 - If not using stdin - the text to be written
function do_log {
  if [ -n "$4" ]
  then
    IN="$4"
  else
    debug_log "Detected stdin"
    read IN
  fi

  echo -e $(format_log $1 "$IN" $3) >> $2
}

function debug_log {
  do_log DEBUG $DEBUG_LOGFILE "$NC" "$1"
}

function main_log {
  do_log LOG $DEBUG_LOGFILE "$NC" "$1"
  do_log LOG $MAIN_LOGFILE "$NC" "$1"
}

function error_log {
  do_log ERROR $DEBUG_LOGFILE "$RED" "$1"
  do_log ERROR $MAIN_LOGFILE "$RED" "$1"
  do_log ERROR $ERROR_LOGFILE "$RED" "$1"
}

