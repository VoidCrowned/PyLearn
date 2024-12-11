#!/usr/bin/env bash


## Text formatting
freset='\033[0m'
fbold='\033[1m'


## Main vars
failed_count=0


## Main loop
t_exec() {
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


## Check privileges
if [ "$EUID" -ne 0 ]; then
    echo -e "Run this script with ${fbold}sudo${freset} or as ${fbold}root${freset}."
    echo -e "Try again. Bailing."
    exit 1
fi


## Task vars
locale_gen="/etc/locale.gen"
locale_conf="/etc/locale.conf"
mirror_opts="-c EU -p https --age 6 --fastest 5 --sort rate --save /etc/pacman.d/mirrorlist"
pacman_settings="/etc/pacman.conf"
pkglist=("base" "linux" "linux-firmware" "intel-ucode")
timezone="Europe/Berlin"
vconsole_conf="/etc/vconsole.conf"


## Tasks
# Pacman mirrorlist update
t_exec "reflector $mirror_opts"

# Pacman settings
if [ -f pacman_settings ] && [ -f $pacman_settings ]; then
    t_exec "cat pacman_settings >> $pacman_settings"
else
    error_msg="File(s) missing:"
    if [ ! -f pacman_settings ]; then
        error_msg+=" pacman_settings"
    fi
    if [ ! -f "$pacman_settings" ]; then
        error_msg+=" $pacman_settings"
    fi
    echo -e "$error_message. Skipping."
fi

# Pacman db update
t_exec "pacman -Syu --noconfirm"

# Pacstrap
t_exec "pacstrap -K /mnt ${pkglist[@]}"

# fstab
t_exec "genfstab -U /mnt >> /mnt/etc/fstab"

# chroot
t_exec "arch-chroot /mnt"

# Pacman mirrorlist update
t_exec "reflector $mirror_opts"

# Pacman settings
if [ -f pacman_settings ] && [ -f $pacman_settings ]; then
    t_exec "cat pacman_settings >> $pacman_settings"
else
    error_msg="File(s) missing:"
    if [ ! -f pacman_settings ]; then
        error_msg+=" pacman_settings"
    fi
    if [ ! -f "$pacman_settings" ]; then
        error_msg+=" $pacman_settings"
    fi
    echo -e "$error_message. Skipping."
fi

# Install other pkgs

# Pacman db update
t_exec "pacman -Syu --noconfirm"

# Date & time
echo -e "Setting timezone to '$timezone'."
t_exec "ln -sf /usr/share/zoneinfo/$timezone /etc/localtime"

# Clock sync
t_exec "hwclock --systohc"

# Localisation
if [ -f "$locale_gen" ]; then
    echo -e "Backing up $locale_gen ..."
    mv "$locale_gen" "${locale_gen}.bak"
fi
# locale.gen
cp locale_gen "$locale_gen"
t_exec "locale-gen"
# locale.conf
if [ -f "$locale_conf" ]; then
    echo -e "Backing up $locale_conf ..."
    mv "$locale_conf" "${locale_conf}.bak"
fi
cp locale_conf "$locale_conf"

# Backup and configure console
if [ -f "$vconsole_conf" ]; then
    echo -e "Backing up $vconsole_conf ..."
    mv "$vconsole_conf" "${vconsole_conf}.bak"
fi
t_exec "echo 'KEYMAP=dvorak' > $vconsole_conf"
t_exec "echo 'FONT=Lat2-Terminus16' >> $vconsole_conf"

# Network config
#    - Hostname

# Initramfs

# User setup

# su/sudo

# Bootloader

# Reboot

# Final check
if [ $failed_count -eq 0 ]; then
    echo -e "All tasks completed successfully!"
    exit 0
else
    echo -e "Script completed with ${fbold}$failed_count${freset} failed task(s)."
    exit 1
fi
