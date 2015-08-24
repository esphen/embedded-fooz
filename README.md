## Development

The view is written in C and has the following requirements:
```
cmake (>=3.0)
libncurses5-dev (ncurses-devel on red hat)
figlet
```

To compile C view, run the following command in root folder.

```
cmake . && make
```

An executable called Curses will then be created, which can be run with `./Curses`.

The C view is completely standalone from the bash program. This means that it is not a requirement to have a Raspberry Pi to hack on the view. You only need to update the scorefile to update the view, as the C program polls it for data.

#### Shell script

The main executable and script used to talk to the GPIO ports on the Raspberry Pi is written in bash. It polls the GPIO pins set in [variables.sh](https://github.com/esphen/embedded-fooz/blob/master/variables.sh) for input, and when it changes, increments the scorefile.

The requirements for the bash script is:
```
wiringPi
play (from SoX)
```

#### Logging
After the main executable `embedded-fooz.sh` is run, a folder called logs will be created. It will contain three logfiles of increasing severity. These are appended to by the bash script, and stderr from the C files.

