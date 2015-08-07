# Generic functions

function get_timestamp {
  echo $(date +%s)
}

function debug_log {
  echo $1 >> $DEBUG_LOGFILE
}

function main_log {
  echo $1 >> $MAIN_LOGFILE
  debug_log $1
}

