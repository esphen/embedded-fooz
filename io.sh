# Reads input on pin $INPUT

LAST_VALUE=1

# Checks if input is detected and updates score file
# $1 is team (BLUE/RED)
# $2 is team score ($BLUE_SCORE, $RED_SCORE)
function check_input {
  local INPUT=1
  local OUTPUT=0
  local VALUE=$(gpio read $INPUT)

  # If signal input has changed
  if [[ $LAST_VALUE -ne $VALUE ]]
  then
    if [[ $VALUE -eq 1 ]]
    then
      set_score $1 $(($2 + 1))
      main_log "$1 player is set to $(($2 + 1))"
    fi
    LAST_VALUE=$VALUE
  fi
}

