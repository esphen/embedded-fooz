## Development

The view is written in C and has the following requirements: 
```
cmake (>=3.0)
libncurses5-dev (ncurses-devel on red hat)
```

To compile C view, run the following command in root folder.

```
cmake . && make
```

An executable called Curses will then be created, which can be run standalone by running `./Curses`
