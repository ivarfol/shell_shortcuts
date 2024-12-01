#!/bin/bash

print_menu () {
    count=0
    for ((i = 0 ; i < $indiv_index+2 ; i++));
    do
        echo $'\e[2A'
    done
    echo $'\e[0J\e[A'
    for name in "${shortcut_name[@]}"; do
        if [ $pointer -eq $count ]; then
            echo $'\e[47m\e[30m' $name $'\e[0m'
        else
            echo $name
        fi
        ((count=count+1))
    done
}

help_f () {
    echo $'\e[H\e[0JHelp'
    echo "w, k to move up"
    echo "s, j to move down"
    echo "enter to run the command"
    echo "h, ? to access this menu"
    echo "q to quit"
    echo "you can customise your menu"
    echo "by changing ~/.shortcuts"
    read -n1 -s
}

move_pointer () {
    tmp=$(($pointer + $1))
    if [ $tmp -gt $indiv_index ];
    then
        pointer=0
    elif [ $tmp -lt 0 ];
    then
        pointer=$((indiv_index))
    else
        ((pointer=pointer+ $1))
    fi
}

load_arr () {
    index=0
    indiv_index=0
    while read line; do
        if [[ "$line" != \#* ]] && [[ "$line" != "" ]]; then
            if [ $index -eq 0 ]; then
                title="$line"
            else
                if [ $(( index % 3 )) -eq 1 ]; then
                    shortcut_name[indiv_index]="$line"
                elif [ $(( index % 3 )) -eq 2 ]; then
                    shortcut_location[indiv_index]="${line/#~/${HOME}}"
                elif [ $(( index % 3 )) -eq 0 ]; then
                    shortcut_command[indiv_index]="$line"
                    ((indiv_index=$indiv_index+1))
                fi
            fi
            ((index=$index+1))
        fi
    done < ~/.shortcuts 
}

main () {
    pointer=0
    load_arr
    echo $'\e[2J\e[H'$title
    ((indiv_index=$indiv_index-1))
    print_menu
    user_input=0
    while [ $user_input != "q" ] && [ $user_input != "Q" ];
    do
        read -n1 -s user_input
        if [ "$user_input" == "" ]; then
            move_to_dir=(cd ${shortcut_location[$pointer]})
            "${move_to_dir[@]}"
            eval ${shortcut_command[$pointer]}
            cd - >/dev/null
            user_input="q"
        elif [ $user_input == "w" ] || [ $user_input == "k" ]; then
            move_pointer -1 $pointer $indiv_index
            print_menu
        elif [ $user_input == "s" ] || [ $user_input == "j" ]; then
            move_pointer 1 $pointer $indiv_index
            print_menu
        elif [ $user_input == "h" ] || [ $user_input == "?" ]; then
            help_f
            echo $'\e[H\e[0J'$title
            print_menu
        fi
    done
}

main
