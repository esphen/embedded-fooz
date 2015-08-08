# Constants
declare -r DIR=$(dirname $0)
declare -r MAIN_LOGFILE=$DIR/logs/main.log
declare -r DEBUG_LOGFILE=$DIR/logs/debug.log
declare -r ERROR_LOGFILE=$DIR/logs/error.log
declare -r FONT=$DIR/lib/doh.flf
declare -r DEFAULT_PIN_IN=1

# Colours
declare -r NC='\033[0m' # No colour
declare -r RED='\033[0;31m'

# Getters and setters (of globals)
function get_scores {
  source $DIR/score.txt
}

# $1 - The player in question (BLUE, RED)
# $2 - The score to set (1-7)
function set_score {
  sed score.txt -i $DIR/score.txt -e "s/\($1.*\)[0-9]/\1$2/"
  get_scores
}

