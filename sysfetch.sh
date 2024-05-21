#!/usr/bin/env bash


#        DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
#                    Version 2, December 2004 
#
# Copyright (C) 2004 Sam Hocevar <sam@hocevar.net> 
#
# Everyone is permitted to copy and distribute verbatim or modified 
# copies of this license document, and changing it is allowed as long 
# as the name is changed. 
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION 
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.


## ----- Reusable variables -----

## Text formatting
freset='\033[0m'
fbold='\033[1m'
fdim='\033[2m'
fuline='\033[4m'
fblink='\033[5m'
finvert='\033[7m'
fhidden='\033[8m'

## Text colour escape codes
fblack='\033[0;30m'
fred='\033[0;31m'
fgreen='\033[0;32m'
fyellow='\033[0;33m'
fblue='\033[0;34m'
fmagenta='\033[0;35m'
fcyan='\033[0;36m'
fwhite='\033[0;37m'

## Background colour escape codes
bblack='\033[0;40m'
bred='\033[0;41m'
bgreen='\033[0;42m'
byellow='\033[0;43m'
bblue='\033[0;44m'
bmagenta='\033[0;45m'
bcyan='\033[0;46m'
bwhite='\033[0;47m'


## ----- Reusable messages -----

logo="
 ${fmagenta}█████████████████████████████████████████████████████
 ${fred}██ ▄▄▄ ██ ███ ██ ▄▄▄ ██ ▄▄▄██ ▄▄▄█▄▄ ▄▄██ ▄▄▀██ ██ ██
 ${fyellow}██▄▄▄▀▀██▄▀▀▀▄██▄▄▄▀▀██ ▄▄███ ▄▄▄███ ████ █████ ▄▄ ██ 
 ${fgreen}██ ▀▀▀ ████ ████ ▀▀▀ ██ █████ ▀▀▀███ ████ ▀▀▄██ ██ ██ 
 ${fblue}█████████████████████████████████████████████████████
${freset}"

m1=" ${fbold}1${freset} Show current disk partitioning"
m2=" ${fbold}2${freset} Show process list"
m3=" ${fbold}3${freset} Find and display files with SUID bit set"
m4=" ${fbold}4${freset} Create users from a list"
m5=" ${fbold}5${freset} Show IPv4 addresses of all interfaces"
m6=" ${fbold}6${freset} Show current Kernel release number"
m7=" ${fbold}7${freset} Show current time and timezone"
m8=" ${fbold}8${freset} Show free and used disk space of the root directory"
m9=" ${fbold}9${freset} Determine and display space usage of user directories under /home"
mq=" ${fbold}q${freset} Quit (usable at any time)\n"


## ----- Tiny functions -----

show_logo() {
    clear -x
    echo -e "${logo}"
}

show_menu() {
    echo -e "\n${m1}"
    echo -e "${m2}"
    echo -e "${m3}"
    echo -e "${m4}"
    echo -e "${m5}"
    echo -e "${m6}"
    echo -e "${m7}"
    echo -e "${m8}"
    echo -e "${m9}"
    echo -e "${mq}"
}

input_prompt() {
    read -n 1 -s choice
}

check_q() {
    if [ "$choice" == "q" ]; then
        echo -e "\n\n ${fbold}q${freset} received, leaving."
        echo -e " Goodbye.\n"
        exit 0
    fi
}

btm_prompt() {
    echo -en "\n Press ${fbold}any${freset} key to return..."
}


## ----- Main functions -----

btm_seq() {
    btm_prompt
    input_prompt
    check_q
}

main_menu() {
    show_logo
    echo -e " Please press a ${fbold}number${freset} to select an option,"
    echo -e " or press ${fbold}q${freset} to exit."
    show_menu
    echo -en " Enter your choice."
    input_prompt
    check_q
}

menu_01() {
    show_logo
    echo -e "${m1}\n"
    df -h | awk '{print " "$0}'
    btm_seq
}

menu_02() {
    show_logo
    echo -e "${m2}\n"
    ps aux | awk '{print " "$0}'
    btm_seq
}

menu_03() {
    show_logo
    echo -e "${m3}\n"
    find / \( -path /proc -o -path /sys -o -path /dev \) -prune -o -type f -perm /4000 -print 2>/dev/null | awk '{print " "$0}'
    btm_seq
}

menu_04() {
    show_logo
    echo -e "${m4}\n"
    listPath="$1"
    ucount=0
    echo -e " Please enter the ${fbold}full path${freset} to the list containing the usernames:\n"
    while true; do
        read -r -p " " listPath
        # Check if the file exists
        if [ -f "$listPath" ]; then
            break
        else
            echo -e "\n File does not exist. Try again:"
        fi
    done
    
    # Loop through each line in the file
    echo -e " Okay, parsing file...\n"
    while IFS= read -r username
    do
        # If a user already exists,
        # throw a warning and skip user creation
        if id "$username" &>/dev/null; then
            echo -e " ${fbold}$username${freset} skipped, already exists."
        else
            # Create a new user
            useradd "$username"
            if [ $? -eq 0 ]; then
                echo -e " ${fbold}$username${freset} created."
                # Set the user's password
                echo "$username:alfa" | chpasswd
                # Expire the password to force a reset on next login
                chage -d 0 "$username"
                ((ucount++))
            fi
        fi
    done < "$listPath"
    
    echo -e "\n Done. $ucount users created."
    echo -e "\n You'll have to add the \$HOME dirs yourself."
    echo -e " Passwords for created users are set to ${fbold}expire${freset}."
    btm_seq
}

menu_05() {
    show_logo
    echo -e "${m5}\n"
    ip -4 addr show | awk '/inet /{print "Interface", $NF, "has the address", $2}' | awk '{print " "$0}'
    btm_seq
}

menu_06() {
    show_logo
    echo -e "${m6}\n"
    uname -r | awk '{print " "$0}'
    btm_seq
}

menu_07() {
    show_logo
    echo -e "${m7}\n"
    echo -e " It is currently ${fbold}$(date +"%T")${freset}, the timezone used is ${fbold}$(date +"%Z")${freset}."
    btm_seq
}

menu_08() {
    show_logo
    echo -e "${m8}\n"
    root_size=$(df -h / | awk 'NR==2 {print $2}')
    root_use=$(df -h / | awk 'NR==2 {gsub("G", "", $3); print $3}')
    root_pct=$(df -h / | awk 'NR==2 {print $5}')
    root_free=$(df -h / | awk 'NR==2 {print $4}')
    echo -e " Querying /"
    echo -e " Used: ${root_use}/${root_size} (${root_pct})"
    echo -e " Free: ${root_free}"
    btm_seq
}

menu_09() {
    show_logo
    echo -e "${m9}\n"
    du -sh /home/* | awk '{print $1, "\t", $2}' | awk '{print " "$0}'
    btm_seq
}

menu_inv() {
    show_logo
    echo -e " Invalid input. Please press a number from ${fbold}1${freset} to ${fbold}9${freset},"
    echo -e " or press ${fbold}q${freset}."
    btm_prompt
    input_prompt
}

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo -e "\n Run this script with ${fbold}sudo${freset} or as ${fbold}root${freset}."
    echo -e " Try again. Bailing.\n"
    exit 1
fi

## ----- Main loop -----
while true; do
    main_menu
    case $choice in

        1)
            menu_01
            ;;

        2)
            menu_02
            ;;

        3)
            menu_03
            ;;

        4)
            menu_04
            ;;

        5)
            menu_05
            ;;

        6)
            menu_06
            ;;

        7)
            menu_07
            ;;

        8)
            menu_08
            ;;

        9)
            menu_09
            ;;

        # Undefined_input
        *)
            menu_inv
            ;;
    esac
done
