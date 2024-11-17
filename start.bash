# function to start and setup the game

source ./.game.bash
exec 2>/dev/null


while IFS= read -r line; do
    for (( i=0; i<${#line}; i++ )); do
        char="${line:i:1}"
        echo -n $char
        if [ "$char" = " " ]; then
            echo -n " "
        fi
        sleep 0.05
    done
    echo
    sleep 0.1
done < "./.data/intro.txt"

mv .remise_zero.bash remise_zero.bash
mv .down.bash down.bash
mv .left.bash left.bash
mv .right.bash right.bash
mv .up.bash up.bash
mv .maze.txt maze.txt


fetch_data
while [ "${matrix[$x_f,$y_f]}" = "F" ]; do

    read_grid
    ./down.bash
    ./up.bash
    ./right.bash
    ./left.bash
    sleep 0.5
    
done


echo "Congratulations! You’ve found your way out of the maze!"

./remise_zero.bash

mv remise_zero.bash .remise_zero.bash
mv down.bash .down.bash
mv left.bash .left.bash
mv right.bash .right.bash
mv up.bash .up.bash
mv maze.txt .maze.txt
