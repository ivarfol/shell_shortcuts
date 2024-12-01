#!/bin/bash

print_menu () {
    count=0
    for ((i = 0 ; i < $indiv_index+2 ; i++));
    do
        echo $'\e[2A'
    done
    echo $'\e[0J\e[A'
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
                echo "$line" >> ~/sh_sh_log.txt
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
    print_menu $shortcut_name $pointer
    user_input=0
    while [ $user_input != "q" ] && [ $user_input != "Q" ];
    do
        read -n1 -s user_input
        if [ "$user_input" == "" ];
        then
            move_to_dir=(cd ${shortcut_location[$pointer]})
            "${move_to_dir[@]}"
            eval ${shortcut_command[$pointer]}
            cd - >/dev/null
            user_input="q"
        elif [ $user_input == "w" ] || [ $user_input == "k" ];
        then
            move_pointer -1 $pointer $indiv_index
            print_menu $shortcut_name $pointer $iniv_index
        elif [ $user_input == "s" ] || [ $user_input == "j" ];
        then
            move_pointer 1 $pointer $indiv_index
            print_menu $shortcut_name $pointer $iniv_index
        fi
    done
}

main
