# Constants
declare -r DIR=$(dirname $0)
declare -r LOGDIR=$DIR/logs
declare -r MAIN_LOGFILE=$LOGDIR/main.log
declare -r DEBUG_LOGFILE=$LOGDIR/debug.log
declare -r ERROR_LOGFILE=$LOGDIR/error.log
declare -r SCOREFILE=$DIR/score.txt
declare -r FONT=$DIR/lib/doh.flf
declare -r DEFAULT_PIN_IN=1
declare -r BLUE_PLAYER_PIN_IN=1
declare -r RED_PLAYER_PIN_IN=0
declare -r WIN_SCORE=7
declare -r WIN_STATE_SECONDS=10s

# Application states
declare -r STATE_NORMAL=Normal
declare -r STATE_WINNER=Winner

# Colours
declare -r NC='\033[0m' # No colour
declare -r RED='\033[0;31m'

