cmake_minimum_required(VERSION 3.0)
project(Curses)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")

find_package(Curses REQUIRED)
include_directories(${CURSES_INCLUDE_DIR})

set(SOURCE_FILES src/main.c)
add_executable(Curses ${SOURCE_FILES})

target_link_libraries(Curses ${CURSES_LIBRARIES})
