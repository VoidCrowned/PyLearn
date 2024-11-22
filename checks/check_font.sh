#!/usr/bin/env bash


## Set font
# Check if the Lat2-terminus16 font exists in the specified directory
echo "Checking for Lat2-terminus16 font."

check_font=$(ls /usr/share/kbd/consolefonts | grep -w 'Lat2-terminus16')

if [[ -n "$available_font" ]]; then
    echo "Font found."
    setfont Lat2-terminus16
    if [[ $? -eq 0 ]]; then
        echo "Set Lat2-terminus16 as the console font."
        exit 0
    else
        echo "Failed to set the console font."
        exit 1
    fi
else
    echo "Font Lat2-terminus16 not found."
    exit 1
fi
