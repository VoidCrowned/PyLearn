#!/usr/bin/env bash


## Set kbm
# List available keyboards and check for dvorak
echo "Checking for 'dvorak' kbmap."

check_kbm=$(localectl list-keymaps | grep -w 'dvorak')

# Check if dvorak exists in the list
if [[ -n "$check_kbm" ]]; then
    echo "Found it."
    loadkeys dvorak
    if [[ $? -eq 0 ]];
        echo "Loaded 'dvorak' kbmap."
        exit 0
    else
        echo "Failed to load."
        exit 1
    fi
else
    echo "Kbmap 'dvorak' not found."
exit 1
fi
