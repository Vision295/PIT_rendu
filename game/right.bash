#!/bin/bash

source ./game.bash

get_all_pos
read_grid
temp=0
while [ $x_b -lt $(($size_x-1)) ] && [ "${matrix[$y_b,$(($x_b+1))]}" != "X" ]; do
    
    if [ "${matrix[$y_b,$(($x_b+1))]}" != "X" ]; then

        matrix[$y_b,$(($x_b+1))]="B"
        matrix[$y_b,$x_b]="0"
        ((x_b++))

        moves["$temp,0"]=$x_b 
        moves["$temp,1"]=$y_b
        ((temp++))

        change_all_pos $x_b $y_b $x_f $y_f

    fi
done
write_grid_to_file_public