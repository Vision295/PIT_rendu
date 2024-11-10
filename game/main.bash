#!/bin/bash
source ./game.bash
exec 2>/dev/null


start
while [ "${matrix[$x_f,$y_f]}" = "F" ]; do

    read_grid
    ./down.bash
    ./up.bash
    ./right.bash
    ./left.bash
    sleep 1
    
done
