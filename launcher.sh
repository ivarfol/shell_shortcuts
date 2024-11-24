#!/bin/bash

main () {
    shortcut_name[0]="Option 1"
    shortcut_name[1]="Option 2"
    shortcut_name[2]="Option 3"
    shortcut_name[3]="Option 4"
    shortcut_location[0]="$HOME"
    shortcut_location[1]="$HOME"
    shortcut_location[2]="$HOME"
    shortcut_location[3]="$HOME"
    shortcut_command[0]="echo 'one'"
    shortcut_command[1]="echo 'two'"
    shortcut_command[2]="echo 'three'"
    shortcut_command[3]="echo 'four'"
    echo "start"
    echo "Choose an option"
    read -p "1, 2, 3, 4? " ans
    echo "You chose" $ans
    echo "You chose" ${shortcut_name[$ans - 1]}
    move_to_dir=(cd ${shortcut_location[$ans - 1]})
    "${move_to_dir[@]}"
    eval ${shortcut_command[$ans - 1]}
    cd - >/dev/null
    echo "end"
}

main
