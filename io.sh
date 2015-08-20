# Reads input on pin $INPUT

# Checks if input is detected and updates score file
# $1 is team (BLUE/RED)
# $2 is team score ($BLUE_SCORE, $RED_SCORE)
# $3 is the last return value of this function (When looping)
# $4 is data input pin (Using wiringPi pin numbers)
function check_input {
  local LAST_VALUE=${3:-1}
  local INPUT=${4:-${DEFAULT_PIN_IN}}
  local VALUE=$(gpio read $INPUT)

  # If signal input has changed
  if [[ $LAST_VALUE -ne $VALUE ]]
  then
    if [[ $VALUE -eq 1 ]]
    then
      local NEW_SCORE=$(($2 + 1))
      set_score $1 $NEW_SCORE
      main_log "$1 player is set to $NEW_SCORE"

      #play_cheer

      if [[ $NEW_SCORE -ge $WIN_SCORE ]]
      then
        # TODO: Do something cool when winner is detected
        main_log "Game over! $1 player is the winner!"
        reset_scores
      fi
    fi
  fi
  echo $VALUE
}

