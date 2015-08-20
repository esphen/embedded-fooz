cmake_minimum_required(VERSION 3.2)
project(Curses)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")

find_package(Curses REQUIRED)
include_directories(${CURSES_INCLUDE_DIR})
#include(/usr/lib64/libncurses.so.5.9)

set(SOURCE_FILES src/main.c)
add_executable(Curses ${SOURCE_FILES})

target_link_libraries(Curses ${CURSES_LIBRARIES})
