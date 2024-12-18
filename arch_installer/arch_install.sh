#!/usr/bin/env bash


# Including main functionality
source ./arch_main.sh

# Check for root privileges
check_priv


## Tasks
# Pacman mirrorlist update
task_exec "reflector $mirror_opts"

# Pacman settings
set_pacman_settings

# Pacman db update
task_exec "pacman -Syu --noconfirm"

# Pacstrap
task_exec "pacstrap -K /mnt ${pkglist[@]}"

# fstab
task_exec "genfstab -U /mnt >> /mnt/etc/fstab"

# chroot
task_exec "arch-chroot /mnt"

# Pacman mirrorlist update
task_exec "reflector $mirror_opts"

# Pacman settings
set_pacman_settings

# Pacman db update
task_exec "pacman -Syu --noconfirm"

# -----
# Install other pkgs
task_exec "pacman -S --noconfirm ${ext_pkglist[@]}"
# -----

# Date & time
echo -e "Setting timezone to '$timezone'."
task_exec "ln -sf /usr/share/zoneinfo/$timezone /etc/localtime"

# Clock sync
task_exec "hwclock --systohc"

# Localisation
# locale.gen
if [ -f "$bcfg/locale.gen.new" ] && [ -f "$locale_gen" ]; then
    echo -e "Backing up $locale_gen ..."
    mv "$locale_gen" "${locale_gen}.bak"
    echo -e "Copying $bcfg/locale.gen.new ..."
    cp "$bcfg/locale.gen.new" "$locale_gen"
else
    error_msg="File(s) missing:"
    if [ ! -f "$bcfg/locale.gen.new" ]; then
        error_msg+=" $bcfg/locale.gen.new"
    fi
    if [ ! -f "$locale_gen" ]; then
        error_msg+=" $locale_gen"
    fi
    echo -e "$error_msg. Skipping."

fi
task_exec "locale-gen"
# locale.conf
if [ -f "$bcfg/locale.conf.new" ] && [ -f "$locale_conf" ]; then
    echo -e "Backing up $locale_conf ..."
    mv "$locale_conf" "${locale_conf}.bak"
    echo -e "Copying $bcfg/locale.conf.new ..."
    cp "$bcfg/locale.conf.new" "$locale_conf"
else
    error_msg="File(s) missing:"
    if [ ! -f "$bcfg/locale.conf.new" ]; then
        error_msg+=" $bcfg/locale.conf.new"
    fi
    if [ ! -f "$locale_conf" ]; then
        error_msg+=" $locale_conf"
    fi
    echo -e "$error_msg. Skipping."
fi

# Console settings
if [ -f "$bcfg/vconsole.conf.new" ] && [ -f "$vconsole_conf" ]; then
    echo -e "Backing up $vconsole_conf ..."
    mv "$vconsole_conf" "${vconsole_conf}.bak"
    echo -e "Copying $bcfg/locale.conf.new ..."
    cp "$bcfg/vconsole.conf.new" "$vconsole_conf"
else
    error_msg="File(s) missing:"
    if [ ! -f "$bcfg/vconsole.conf.new" ]; then
        error_msg+=" $bcfg/vconsole.conf.new"
    fi
    if [ ! -f "$vconsole_conf" ]; then
        error_msg+=" $vconsole_conf"
    fi
    echo -e "$error_msg. Skipping."
fi

# Network config
read -rp "Hostname: " hostname
task_exec 'hostnamectl hostname "$hostname"'

# -----
# Initramfs
task_exec "mkinitcpio -P"

# User setup
if confirm "Is '$user_name' the correct username?"; then
    create_user
else
    read -rp "Enter a new username: " user_name
    create_user
fi

# su/sudo
#passwd root root

# Bootloader

# Reboot
# -----

# Final check
if [ $failed_count -eq 0 ]; then
    echo -e "All tasks completed successfully!"
    exit 0
else
    echo -e "Script completed with ${fbold}$failed_count${freset} failed task(s)."
    exit 1
fi
