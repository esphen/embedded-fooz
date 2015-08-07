# Reads input on pin $INPUT

LAST_VALUE=1

function check_input {
  local INPUT=1
  local OUTPUT=0
  local VALUE=$(gpio read $INPUT)


  # If signal input has changed
  if [[ $LAST_VALUE -ne $VALUE ]]
  then
    if [[ $VALUE -eq 1 ]]
    then
      get_scores
      set_score BLUE $(($BLUE_SCORE + 1))
      main_log "Input is set to $(($BLUE_SCORE + 1))"
    fi
    LAST_VALUE=$VALUE
  fi
}

