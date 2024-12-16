#!/usr/bin/env bash


## Verify boot mode
# Check if we're in EFI mode by inspecting /sys/firmware/efi/fw_platform_size
check_efi() {
    echo "Checking if the system is booted in EFI mode."
    efi_mode=$(cat /sys/firmware/efi/fw_platform_size)
    # If the value is 64, we're in EFI mode
    if [[ "$efi_mode" -eq 64 ]]; then
        echo "System is booted in EFI mode."
        exit 0
    else
        echo "System is not booted in EFI mode."
        exit 1
    fi
}


## Set font
# Check if the Lat2-terminus16 font exists in the specified directory
check_font() {
    echo "Checking for Lat2-terminus16 font."
    available_font=$(ls /usr/share/kbd/consolefonts | grep -w 'Lat2-terminus16')
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
}


## Set kbm
# List available keyboards and check for dvorak
check_kbm() {
    echo "Checking for 'dvorak' kbmap."
    available_kbm=$(localectl list-keymaps | grep -w 'dvorak')
    # Check if dvorak exists in the list
    if [[ -n "$available_kbm" ]]; then
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
}
