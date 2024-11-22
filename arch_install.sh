#!/usr/bin/env bash


# List of scripts to run
scripts=("check_kbm.sh" "check_font.sh" "check_boot.sh")

# Loop through each script
for script in "${scripts[@]}"; do
    echo "Running $script."
    # Execute each script
    ./$script
    if [[ $? -ne 0 ]]; then
        echo "$script failed. Exiting."
        exit 1
    fi
done

echo "All scripts executed successfully!"
exit 0
#!/usr/bin/env bash


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
