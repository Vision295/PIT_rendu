#!/bin/bash
declare -A matrix
declare -A moves
size_x=0 size_y=0 x_b=0 y_b=0 x_f=0 y_f=0

read_grid() {
    # reads grid from file super_secret_maze.txt to get its corresponding value in a matrix (without the borders)
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
    done < "./.data/super_secret_maze.txt"
    # GLOBAL VAR : size_y
    size_y=$row
}

print_matrix() {
    # Print the matrix (for demonstration)
    for ((i=0; i<size_y; i++))
    do
        for ((j=0; j<size_x; j++))
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

write_on_file_private() {
    # prints the grid in the file : super_secret_maze.txt
    # prints the grid with the borders all arround
    exec 3> ./.data/super_secret_maze.txt
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

write_on_file_public() {
    count=0
    while [ -n "${moves["$count,0"]}" ]; do
        vali="${moves["$count,1"]}" valj="${moves["$count,0"]}"
        matrix["$vali,$valj"]=1
        
        ((count++))
    done

    # prints the grid in the file : maze.txt
    # prints the grid with the borders all arround
    exec 3> ./maze.txt
    # upper grid
    for ((i=0; i<size_x+2; i++)); do 
        echo -n "- " >&3
    done
    echo >&3
    # core grid with spaces between and walls at the beginning and at the end
    for ((i=0; i<size_y; i++)); do
        echo -n "| " >&3
        for ((j=0; j<size_x; j++)); do
            if [ "${matrix["$i,$j"]}" = "1" ]; then
                echo -n "0 " >&3
            elif [ "${matrix["$i,$j"]}" != "0" ]; then
                echo -n "${matrix[$i,$j]} " >&3
            else 
                echo -n "X " >&3
            fi
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

get_all_pos() {
    # function to get the position of the player and the position of the finish point and store those values in a file called game_data/./.data/data.txt
    exec 3< "./.data/data.txt"
    read -r x_b <&3  
    read -r y_b <&3  
    read -r x_f <&3  
    read -r y_f <&3
    exec 3<&-
}

change_all_pos() {
    # function to set the new player's position ($1 and $2) and the new finish position ($3 and $4)
    echo "$1" > ./.data/data.txt
    echo "$2" >> ./.data/data.txt
    echo "$3" >> ./.data/data.txt
    echo "$4" >> ./.data/data.txt
}

fetch_data() {
    read_grid
    get_all_pos
}