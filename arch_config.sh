#!/usr/bin/env bash


## Text formatting
freset='\033[0m'
fbold='\033[1m'

# Check privileges
if [ "$EUID" -ne 0 ]; then
    echo -e "\n Run this script with ${fbold}sudo${freset} or as ${fbold}root${freset}."
    echo -e " Try again. Bailing.\n"
    exit 1
fi

# Update reflector for better mirrors
reflector -c EU -p https --age 6 --fastest 5 --sort rate --save /etc/pacman.d/mirrorlist
echo "Updated mirrors."
cat pacman_settings >> /etc/pacman.conf
echo "Appended pacman_settings to pacman.conf."

# List of scripts to run
scripts=("check_kbm.sh" "check_font.sh" "check_boot.sh")

# Main loop
for script in "${scripts[@]}"; do
    echo "Running $script."
    # Execute each script
    ./checks/$script
    if [[ $? -ne 0 ]]; then
        echo "$script failed. Exiting."
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

## Installation
#    - `pacstrap -K /mnt base linux linux-firmware`

## Fstab
#    - watch proper boot load order

## Chroot

## Date & Time

## Localisation

## Network config
#    - Hostname

## Initramfs

## User setup

## su/sudo

## Bootloader

## Reboot
