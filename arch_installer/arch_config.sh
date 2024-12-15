#!/usr/bin/env bash


# Including main functionality
source ./arch_main.sh

# Check for root privileges
check_priv


# Update reflector for better mirrors
t_exec "reflector $mirror_opts"
#echo "Updated mirrors."
#cat pacman.conf.add >> /etc/pacman.conf
#echo "Appended pacman.conf.add to pacman.conf."

# List of scripts to run
scripts=("check_kbm.sh" "check_font.sh" "check_boot.sh")

# Main loop
for script in "${scripts[@]}"; do
    echo -e "Running $script."
    ./checks/$script
    if [[ $? -ne 0 ]]; then
        echo -e "$script failed. Exiting."
        exit 1
    fi
done

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
