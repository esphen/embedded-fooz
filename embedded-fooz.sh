#! /bin/bash
echo
echo ' _____ ___  ____   ___  _
|_   _/ _ \|  _ \ / _ \| |
  | || | | | | | | | | | |
  | || |_| | |_| | |_| |_|
  |_| \___/|____/ \___/(_)'
echo

# Reads input on pin $INPUT

INPUT=0
OUTPUT=1
LAST_VAL=0

while true
do
  VALUE=$(gpio read $INPUT)
  gpio write $OUTPUT $VALUE

  # If signal input has changed
  if [ $LAST_VALUE -ne $VALUE ]
  then
    if [ $VALUE -eq 1 ]
    then
      echo 'Input is detected'
    else
      echo 'Input signal no longer detected'
    fi
    LAST=$VALUE
  fi
done

exit 0
