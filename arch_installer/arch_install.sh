#!/usr/bin/env bash


# Including main functionality
source ./arch_main.sh

# Check for root privileges
check_priv


## Tasks
# Pacman mirrorlist update
task_exec "reflector $mirror_opts"

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

# Pacman db update
task_exec "pacman -Syu --noconfirm"

# -----
# Install other pkgs
task_exec "pacman -S --noconfirm neovim sudo"
# -----

# Date & time
echo -e "Setting timezone to '$timezone'."
task_exec "ln -sf /usr/share/zoneinfo/$timezone /etc/localtime"

# Clock sync
task_exec "hwclock --systohc"

# Localisation
# locale.gen
if [ -f $bcfg/locale.gen.new ] && [ -f "$locale_gen" ]; then
    echo -e "Backing up $locale_gen ..."
    mv "$locale_gen" "${locale_gen}.bak"
    echo -e "Copying $bcfg/locale.gen.new ..."
    cp $bcfg/locale.gen.new "$locale_gen"
else
    error_msg="File(s) missing:"
    if [ ! -f $bcfg/locale.gen.new ]; then
        error_msg+=" $bcfg/locale.gen.new"
    fi
    if [ ! -f "$locale_gen" ]; then
        error_msg+=" $locale_gen"
    fi
    echo -e "$error_message. Skipping."

fi
task_exec "locale-gen"
# locale.conf
if [ -f $bcfg/locale.conf.new ] && [ -f "$locale_conf" ]; then
    echo -e "Backing up $locale_conf ..."
    mv "$locale_conf" "${locale_conf}.bak"
    echo -e "Coping $bcfg/locale.conf.new ..."
    cp $bcfg/locale.conf.new "$locale_conf"
else
    error_msg="File(s) missing:"
    if [ ! -f $bcfg/locale.conf.new ]; then
        error_msg+=" $bcfg/locale.conf.new"
    fi
    if [ ! -f "$locale_conf" ]; then
        error_msg+=" $locale_conf"
    fi
    echo -e "$error_message. Skipping."
fi

# Console settings
if [ -f $bcfg/vconsole.conf.new ] && [ -f "$vconsole_conf" ]; then
    echo -e "Backing up $vconsole_conf ..."
    mv "$vconsole_conf" "${vconsole_conf}.bak"
    echo -e "Coping $bcfg/locale.conf.new ..."
    cp $bcfg/vconsole.conf.new "$vconsole_conf"
else
    error_msg="File(s) missing:"
    if [ ! -f $bcfg/vconsole.conf.new ]; then
        error_msg+=" $bcfg/vconsole.conf.new"
    fi
    if [ ! -f "$vconsole_conf" ]; then
        error_msg+=" $vconsole_conf"
    fi
    echo -e "$error_message. Skipping."
fi

# Network config
task_exec "hostnamectl hostname sovereign_arch"

# -----
# Initramfs
task_exec "mkinitcpio -P"

# User setup
task_exec "useradd -m -G wheel -s /bin/zsh void"
passwd void

# su/sudo

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
