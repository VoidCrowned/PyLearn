#!/usr/bin/env bash


# Main script collection
# Include this in every other script,
# to ensure proper functionality.
#
# Run
# arch_precheck.sh
# arch_install.sh
#
# Edit vars below as needed.


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


# File vars
bcfg="./base_configs"
locale_gen="/etc/locale.gen"
locale_conf="/etc/locale.conf"
vconsole_conf="/etc/vconsole.conf"
pacman_settings="/etc/pacman.conf"

# Sys vars
pref_kbm="dvorak"
pref_font="Lat2-Terminus16"
timezone="Europe/Berlin"

# Pacman vars
mirror_opts="-c EU -p https --age 6 --fastest 5 --sort rate --save /etc/pacman.d/mirrorlist"
pkglist=("base" "linux" "linux-firmware" "intel-ucode")


# Pacman settings
set_pacman_settings() {
    if [ -f $bcfg/pacman.conf.add ] && [ -f $pacman_settings ]; then
        task_exec "cat $bcfg/pacman.conf.add >> $pacman_settings"
    else
        error_msg="File(s) missing:"
        if [ ! -f $bcfg/pacman.conf.add ]; then
            error_msg+=" $bcfg/pacman.conf.add"
        fi
        if [ ! -f "$pacman_settings" ]; then
            error_msg+=" $pacman_settings"
        fi
        echo -e "$error_message. Skipping."
    fi
}

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


# Verify boot mode
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


# Set font
# Check if the $pref_font exists in the specified directory
check_font() {
    echo "Checking for '$pref_font' font."
    available_font=$(ls /usr/share/kbd/consolefonts | grep -w "$pref_font")
    if [[ -n "$available_font" ]]; then
        echo "Font '$pref_font' found."
        setfont $pref_font
        if [[ $? -eq 0 ]]; then
            echo "Set '$pref_font' as the console font."
            exit 0
        else
            echo "Failed to set the console font to '$pref_font'."
            exit 1
        fi
    else
        echo "Font '$pref_font' not found."
        exit 1
    fi
}


# Set kbm
# List available keyboards and check for $pref_kbm
check_kbm() {
    echo -e "Checking for '$pref_kbm' kbmap."
    available_kbm=$(localectl list-keymaps | grep -w "$pref_kbm")
    # Check if kbm  exists in the list
    if [[ -n "$available_kbm" ]]; then
        echo "Kbmap '$pref_kbm' found."
        loadkeys "$pref_kbm"
        if [[ $? -eq 0 ]];
            echo "Loaded '$pref_kbm' kbmap."
            exit 0
        else
            echo "Failed to load '$pref_kbm' kbmap."
            exit 1
        fi
    else
        echo "Kbmap '$pref_kbm' not found."
    exit 1
    fi
}
