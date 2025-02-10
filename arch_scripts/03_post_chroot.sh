#!/usr/bin/env bash

##
## Use and modify as needed.
## - VoidCrowned
##

source 00_settings.sh
source 99_styles.sh

check_priv
set +ex

# Set kbd & font to work with
loadkeys dvorak
setfont Lat2-Terminus16

# Mandatory checks
ip link
ping -c 3 archlinux.org
timedatectl

# vconsole.conf
cat <<EOF >> /etc/vconsole.conf
KEYMAP=dvorak
FONT=Lat2-Terminus16
EOF

# locale.conf
cat <<EOF >> /etc/locale.conf
LANG=en_GB.UTF-8
LANGUAGE=en_GB
LC_ADDRESS=de_DE.UTF-8
LC_IDENTIFICATION=de_DE.UTF-8
LC_MEASUREMENT=de_DE.UTF-8
LC_MONETARY=de_DE.UTF-8
LC_NAME=de_DE.UTF-8
LC_NUMERIC=de_DE.UTF-8
LC_PAPER=de_DE.UTF-8
LC_TELEPHONE=de_DE.UTF-8
EOF

# locale.gen
cat <<EOF >> /etc/locale.gen
de_DE.UTF-8 UTF-8
en_GB.UTF-8 UTF-8
ko_KR.UTF-8 UTF-8
EOF

# Generate locales
locale-gen

# Date & time
ln -sf /usr/share/zoneinfo/"$timezone" /etc/localtime
timedatectl

# Clock sync
hwclock --systohc

# Update mirrors
reflector "$mirror_opts" --save /etc/pacman.d/mirrorlist

# pacman.conf
cat <<EOF >> /etc/pacman.conf

# PERSONAL SETTINGS
Color
ParallelDownloads = 10
VerbosePkgLists

SigLevel = Required DatabaseOptional
LocalFileSigLevel = Optional

[community]
Include = /etc/pacman.d/mirrorlist

[multilib]
Include = /etc/pacman.d/mirrorlist
EOF

# Update pacman
pacman -Syu

# Install additional packages
pacman -S "${post_pkglist[@]}" 

# Network config
hostnamectl hostname "$hostname"

# User management
useradd -m -G wheel -s /bin/zsh "$user_name"
passwd "$user_name"

# sudo setup
# Bootloader
# mkinitcpio -P

# Time to reboot,
# then proceed with 04_after_reboot.sh
