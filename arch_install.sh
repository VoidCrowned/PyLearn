#!/usr/bin/env bash


## Text formatting
freset='\033[0m'
fbold='\033[1m'

## Success?
success() {
    if [ $? -eq 0 ]; then
        echo $suc
        exit 0
    else
        echo $err
        exit 1
    fi
}

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

# Installing base system
echo "Installing system base & CPU security patches."
pacstrap -K /mnt base linux linux-firmware intel-ucode 

# fstab & chroot
#genfstab -U /mnt >> /mnt/etc/fstab
#arch-chroot /mnt

# Update pacman files
echo "Updating pacman files."
#pacman -Syu

# Date & Time
echo "Setting time to 'Europe/Berlin'."
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

echo "Syncronising hw clock with sys clock."
hwclock --systohc

## Localisation
# Edit '/etc/locale.gen', uncomment langs
# Then run 'locale-gen'
## Create locale.conf
#mv /etc/locale.conf /etc/locale.conf.bak
#mv /etc/locale.conf.new /etc/locale.conf

## Persistent console settings
suc="Console kbm set successfully."
err="Failed to set console kbm."
echo "Creating backup of '/etc/vconsole.conf'."
cp /etc/vconsole.conf /etc/vconsole.conf.bak
echo "Setting console kbm."
echo "KEYMAP=dvorak" >> /etc/vconsole.conf
success

suc="Console font set successfully."
err="Failed to set console font."
echo "Setting console font."
echo "FONT=LAT2-terminus16" >> /etc/vconsole.conf
success

# Network config
#    - Hostname

# Initramfs

# User setup

# su/sudo

# Bootloader

# Reboot

echo "All scripts executed successfully!"
exit 0
