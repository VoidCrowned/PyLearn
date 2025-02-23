#!/usr/bin/env bash

##
## Use and modify as needed.
## - VoidCrowned
##

source 00_settings.sh
source 99_styles.sh

check_priv
set -ex

# Set kbd & font to work with
loadkeys dvorak
setfont Lat2-Terminus16

# Mandatory checks
ip link
ping -c 3 archlinux.org
timedatectl

# Optimise and update pacman
reflector "$mirror_opts" --save /etc/pacman.d/mirrorlist
cat <<EOF >> /etc/pacman.conf

# PERSONAL SETTINGS
[options]
Color
ParallelDownloads = 10
VerbosePkgList
EOF

# Install necessary packages
pacman -S --noconfirm git

# Figure out your FS,
# cfdisk, zswap, mkfs.ext4, mkswap/swapon
# then proceed with 02_pre_chroot.sh
