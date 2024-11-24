#!/usr/bin/env bash


# Update reflector for better mirrors
reflector -c EU -p https --age 6 --fastest 5 --sort rate --save /etc/pacman.d/mirrorlist
echo "Updated mirrors."
cat pacman_settings >> /etc/pacman.conf
echo "Appended pacman_settings to pacman.conf."

# List of scripts to run
scripts=("check_kbm.sh" "check_font.sh" "check_boot.sh")

# Loop through each script
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
