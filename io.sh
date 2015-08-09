# Reads input on pin $INPUT

LAST_VALUE=1

# Checks if input is detected and updates score file
# $1 is team (BLUE/RED)
# $2 is team score ($BLUE_SCORE, $RED_SCORE)
# $3 is data input pin (Using wiringPi pin numbers)
function check_input {
  local INPUT=${3:-${DEFAULT_PIN_IN}}
  local VALUE=$(gpio read $INPUT 2> >(error_log))

  # If signal input has changed
  if [[ $LAST_VALUE -ne $VALUE ]]
  then
    if [[ $VALUE -eq 1 ]]
    then
      local NEW_SCORE=$(($2 + 1))
      set_score $1 $NEW_SCORE
      main_log "$1 player is set to $NEW_SCORE"

      play_cheer

      if [[ $NEW_SCORE -eq $WIN_SCORE ]]
      then
        # TODO: Do something cool when winner is detected
        main_log "Game over! $1 player is the winner!"
        reset_scores
      fi
    fi
    LAST_VALUE=$VALUE
  fi
}

