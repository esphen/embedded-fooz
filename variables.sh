# Constants
declare -r DIR=$(dirname $0)
declare -r ERRORLOG=$DIR/logs/error.log
declare -r FONT=$DIR/lib/doh.flf

# Globals

# Getters and setters (of globals)
function get_scores {
	source $DIR/score.txt
}

function set_score {
	sed score.txt -i $DIR/score.txt -e "s/\($1.*\)[0-9]/\1$2/"
	get_scores
}

