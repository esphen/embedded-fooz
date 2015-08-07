#! /bin/bash
echo
echo ' _____ ___  ____   ___  _
|_   _/ _ \|  _ \ / _ \| |
  | || | | | | | | | | | |
  | || |_| | |_| | |_| |_|
  |_| \___/|____/ \___/(_)'
echo

# Reads input on pin $INPUT

DIR=$(dirname $0)
INPUT=1
OUTPUT=0
LAST_VALUE=1

function set_score {
	sed score.txt -i $DIR/score.txt -e "s/\($1.*\)[0-9]/\1$2/"
}

function get_scores {
	source $DIR/score.txt
}

while true
do
  VALUE=$(gpio read $INPUT)
  #gpio write $OUTPUT $VALUE

  # If signal input has changed
  if [[ $LAST_VALUE -ne $VALUE ]]
  then
    if [[ $VALUE -eq 1 ]]
    then
      get_scores
      set_score BLUE $(($BLUE_SCORE + 1))
      echo "Input is set to $(($BLUE_SCORE + 1))"
    fi
    LAST_VALUE=$VALUE
  fi
done

exit 0
