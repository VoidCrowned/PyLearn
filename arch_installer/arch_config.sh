#!/usr/bin/env bash


# Including main functionality
source ./arch_main.sh
source ./pre_check.sh

# Check for root privileges
check_priv


# Update reflector for better mirrors
t_exec "reflector $mirror_opts"

# Pacman settings
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

# List of scripts to run
#scripts=("check_kbm.sh" "check_font.sh" "check_boot.sh")

# Main loop
check_efi
check_font
check_kbm
#for script in "${scripts[@]}"; do
#    echo -e "Running $script."
#    ./checks/$script
#    if [[ $? -ne 0 ]]; then
#        echo -e "$script failed. Exiting."
#        exit 1
#    fi
#done

echo "All scripts executed successfully!"
echo "Please proceed with disk partitioning."
exit 0


## Checklist
# [x] set kbd
# [x] set font
# [x] Check boot mode
# [ ] Check internet connection
# [ ] set date & time
# timedatectl set-timezone Europe/Berlin

## Partition disks
#    - call `cfdisk`, then return
#    - summarise partition table
#    - `lsblk`

## Format disks
#    - `lsblk`
#    - `mkfs`
#    - swap y/n
#    - `mkswap`

## Mount it all
#    - `mount --mkdir`
#    - `swapon`

## Reboot
