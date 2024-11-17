chmod 444 left.bash
chmod 444 up.bash
chmod 444 down.bash
chmod 444 right.bash


# data, maze 
source ./.game.bash

cp ./.data/all_levels.txt ./.data/super_secret_maze.txt

read_grid
write_grid_to_file
get_all_pos
change_all_pos 0 0 $x_f $y_f
