#!/bin/bash

print_menu () {
    count=0
    echo $'\e[6A\e[0J'
    for name in "${shortcut_name[@]}";
    do
        if [ "${@: -1}" -eq $count ];
        then
            echo $'\e[47m\e[30m' $name $'\e[0m'
        else
            echo $name
        fi
        ((count=count+1))
    done
}

move_pointer () {
    tmp=$(($pointer + $1))
    if [ $tmp -gt $arr_length ];
    then
        pointer=0
    elif [ $tmp -lt 0 ];
    then
        pointer=$((arr_length))
    else
        ((pointer=pointer+ $1))
    fi
}

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
    pointer=0
    echo
    echo
    echo
    echo
    echo
    echo
    print_menu $shortcut_name $pointer
    user_input=0
    arr_length=3
    while [ $user_input != "q" ] && [ $user_input != "Q" ];
    do
        echo "next"
        read -n1 -s user_input
        if [ "$user_input" == "" ];
        then
            move_to_dir=(cd ${shortcut_location[$pointer]})
            "${move_to_dir[@]}"
            eval ${shortcut_command[$pointer]}
            cd - >/dev/null
            user_input=0
        elif [ $user_input == "w" ] || [ $user_input == "k" ];
        then
            move_pointer -1 $pointer $arr_length
            print_menu $shortcut_name $pointer
        elif [ $user_input == "s" ] || [ $user_input == "j" ];
        then
            move_pointer 1 $pointer $arr_length
            print_menu $shortcut_name $pointer
        fi
    done
}

main
