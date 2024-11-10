#!/bin/bash
declare -A matrix
declare -A moves
size_x=0 size_y=0 x_b=0 y_b=0 x_f=0 y_f=0

read_grid() {
    # reads grid from file game_data/super_secret_maze.txt to get its corresponding value in a matrix (without the borders)
    local j=-1 row=0
    # reading the file
    while IFS= read -r line || [[ -n "$line" ]]; do
        col=0
        # iterating through lines
        for (( i=1; i<${#line}; i++ )); do
            char="${line:i:1}"
            # if the character read this way corresponds to the player's position
            if [ "$char" = "B" ]; then
                x_b=$col y_b=$row
            fi
            # if what we reed is a real character of the matrix (not the borders)
            if [[ "$char" != "-" && "$char" != "|" && "$char" != " " ]]; then
                # Store the valid character in the matrix using (row,col) as the key
                matrix["$row,$col"]="$char"
                ((col++))
            # if it's a border than it means that we change colonm <=> [ i = 1 ]
            elif [ "$char" = "|" ]; then
                if [ $col != 0 ]; then
                    # GLOBAL VAR : size_x
                    size_x=$col
                fi
                col=0 
                ((row++))
            fi
        done
    done < "game_data/super_secret_maze.txt"
    # GLOBAL VAR : size_y
    size_y=$row
}

print_matrix() {
    # Print the matrix (for demonstration)
    for ((i=0; i<y; i++))
    do
        for ((j=0; j<x; j++))
        do
            echo -n "${matrix[$i,$j]} "
        done
        echo
    done
}


write_grid_to_file() {
    write_on_file_public
    write_on_file_private
}

write_on_file_public() {
    # prints the grid in the file : game_data/super_secret_maze.txt
    # prints the grid with the borders all arround
    exec 3> game_data/super_secret_maze.txt
    # upper grid
    for ((i=0; i<size_x+2; i++)); do 
        echo -n "- " >&3
    done
    echo >&3
    # core grid with spaces between and walls at the beginning and at the end
    for ((i=0; i<size_y; i++)); do
        echo -n "| " >&3
        for ((j=0; j<size_x; j++)); do
            echo -n "${matrix[$i,$j]} " >&3
        done
        echo "|" >&3
    done
    # lower grid
    for ((i=0; i<size_x+2; i++)); do 
        echo -n "- " >&3
    done
    echo >&3
    exec 3>&-
}

write_on_file_private() {
    count=0
    while [ -n "${moves["$count,0"]}" ]; do
        matrix[$moves["$count,0"]]
        
        ((count++))
    done
}

get_all_pos() {
    # function to get the position of the player and the position of the finish point and store those values in a file called game_data/game_data/data.txt
    exec 3< "game_data/data.txt"
    read -r x_b <&3  
    read -r y_b <&3  
    read -r x_f <&3  
    read -r y_f <&3
    exec 3<&-
}

change_all_pos() {
    # function to set the new player's position ($1 and $2) and the new finish position ($3 and $4)
    echo "$1" > game_data/data.txt
    echo "$2" >> game_data/data.txt
    echo "$3" >> game_data/data.txt
    echo "$4" >> game_data/data.txt
}

start() {
    read_grid
    get_all_pos
}