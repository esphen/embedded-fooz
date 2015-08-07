# Constants
declare -r DIR=$(dirname $0)
declare -r MAIN_LOGFILE=$DIR/logs/main.log
declare -r DEBUG_LOGFILE=$DIR/logs/debug.log
declare -r ERROR_LOGFILE=$DIR/logs/error.log
declare -r FONT=$DIR/lib/doh.flf

# Globals
# How often we redraw in sec
REDRAW_TIME=1

# Getters and setters (of globals)
function get_scores {
	source $DIR/score.txt
}

function set_score {
	sed score.txt -i $DIR/score.txt -e "s/\($1.*\)[0-9]/\1$2/"
	get_scores
}

