## Development

The view is written in C and has the following requirements: 
```
cmake (>=3.0)
libncurses5-dev (ncurses-devel on red hat)
figlet
wiringPi
play (from SoX)
```

To compile C view, run the following command in root folder.

```
cmake . && make
```

An executable called Curses will then be created, which can be run with `./Curses`.

The C view is completely standalone from the bash program. This means that it is not a requirement to have a Raspberry Pi to hack on the view. You only need to update the scorefile to update the view, as the C program polls it for data.
