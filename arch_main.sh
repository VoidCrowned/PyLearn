#!/usr/bin/env bash


# Main script collection
# Include this in every other script for functionality


# Text formatting
freset='\033[0m'
fbold='\033[1m'


# Check privileges
check_priv() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "Run this script with ${fbold}sudo${freset} or as ${fbold}root${freset}."
        echo -e "Try again. Bailing."
        exit 1
    fi
}


# Pacman vars
mirror_opts="-c EU -p https --age 6 --fastest 5 --sort rate --save /etc/pacman.d/mirrorlist"


# Main loop
failed_count=0
task_exec() {
    local task="$1"
    echo -e "Executing '$task' ..."
    eval "$task"
    local status=$?
    if [ $status -eq 0 ]; then
        echo -e "Successfully executed '$task'."
    else
        echo -e "Failed to execute '$task'."
        failed_count=$((failed_count + 1))
    fi
}
