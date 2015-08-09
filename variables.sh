# Constants
declare -r DIR=$(dirname $0)
declare -r LOGDIR=$DIR/logs
declare -r MAIN_LOGFILE=$LOGDIR/main.log
declare -r DEBUG_LOGFILE=$LOGDIR/debug.log
declare -r ERROR_LOGFILE=$LOGDIR/error.log
declare -r SCOREFILE=$DIR/score.txt
declare -r FONT=$DIR/lib/doh.flf
declare -r DEFAULT_PIN_IN=1
declare -r WIN_SCORE=7

# Colours
declare -r NC='\033[0m' # No colour
declare -r RED='\033[0;31m'

