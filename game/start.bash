# function to start and setup the game
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
done < "intro.txt"
