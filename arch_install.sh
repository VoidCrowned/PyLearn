#!/usr/bin/env bash


## Text formatting
freset='\033[0m'
fbold='\033[1m'

## Success?
success() {
    if [ $? -eq 0 ]; then
        echo -e $suc
        exit 0
    else
        echo -e $err
        exit 1
    fi
}

# Check privileges
if [ "$EUID" -ne 0 ]; then
    echo -e "\n Run this script with ${fbold}sudo${freset} or as ${fbold}root${freset}."
    echo -e " Try again. Bailing.\n"
    exit 1
fi

## Pacman mirrorlist update
task="Pacman mirrorlist update"
suc="Successfully executed '$task'."
err="Failed to execute '$task'."
echo -e "Updating pacman mirrolist..."
reflector -c EU -p https --age 6 --fastest 5 --sort rate --save /etc/pacman.d/mirrorlist
success

## Pacman settigs
suc="Updated pacman.conf..."
err="Failed to update pacman.conf."
echo -e "Updatiing pacman.conf."
cat pacman_settings >> /etc/pacman.conf
success


## Pacman db update
suc="Updated pacman db."
err="Failed to update pacman."
echo -e "Updating pacman..."
pacman -Syu --noconfirm
success


## Pacstrap
pkglist=("base" "linux" "linux-firmware" "intel-ucode")
suc="Done!"
err="Oops!"
echo -e "Pacstrapping $pkglist."
pacstrap -K $pkglist
success


## fstab
suc="Generated fstab successfully."
err="Failed to generate fstab."
echo -e "Generating fstab..."
#genfstab -U /mnt >> /mnt/etc/fstab
success

## chroot
suc="Successfully chrooted."
err="Failed to execute chroot."
echo -e "Chrooting..."
arch-chroot /mnt
success

## Update pacman files
suc="Updated pacman mirrorlist..."
err="Failed to update pacman mirrorlist."
echo -e "Updating pacman mirrolist."
reflector -c EU -p https --age 6 --fastest 5 --sort rate --save /etc/pacman.d/mirrorlist
success

## Pacman settigs
suc="Updated pacman.conf..."
err="Failed to update pacman.conf."
echo -e "Updatiing pacman.conf."
cat pacman_settings >> /etc/pacman.conf
success


## Pacman db update
#suc="Updated pacman db."
#err="Failed to update pacman."
#echo -e "Updating pacman..."
#pacman -Syu --noconfirm
#success

## Date & time
suc="Date & time set."
err="Failed to set date & time."
echo -e "Setting date & time..."
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
success

## Clock sync
suc="Sysclock synced to hwclock."
err="Failed to sync sysclock to hwclock."
echo -e "Syncing sysclock to hwclock..."
hwclock --systohc
success


## Localisation
suc=""
err=""
# Edit '/etc/locale.gen', uncomment langs
# Then run 'locale-gen'
## Create locale.conf
#mv /etc/locale.conf /etc/locale.conf.bak
#mv /etc/locale.conf.new /etc/locale.conf


## Persistent console settings
# KBM
suc="Console kbm set successfully."
err="Failed to set console kbm."
echo -e "Creating backup of '/etc/vconsole.conf'."
cp /etc/vconsole.conf /etc/vconsole.conf.bak
echo -e "Setting console kbm."
echo -e "KEYMAP=dvorak" >> /etc/vconsole.conf
success

# Font
suc="Console font set successfully."
err="Failed to set console font."
echo -e "Setting console font."
echo -e "FONT=Lat2-Terminus16" >> /etc/vconsole.conf
success

# Network config
#    - Hostname

# Initramfs

# User setup

# su/sudo

# Bootloader

# Reboot

echo -e "All scripts executed successfully!"
exit 0
