#!/bin/bash

source ./game.bash

get_all_pos
read_grid
while [ $y_b -lt $(($size_y-1)) ] && [ "${matrix[$(($y_b+1)),$x_b]}" != "X" ]; do
    
    if [ "${matrix[$(($y_b+1)),$x_b]}" != "X" ]; then

        matrix[$(($y_b+1)),$x_b]="B"
        matrix[$y_b,$x_b]="0"
        ((y_b++))

        change_all_pos $x_b $y_b $x_f $y_f
    fi
done
write_grid_to_file