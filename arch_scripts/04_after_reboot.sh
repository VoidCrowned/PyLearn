#!/usr/bin/env bash

##
## Use and modify as needed.
## - VoidCrowned
##

source 00_settings.sh
source 99_styles.sh

check_priv
set -ex

# Install the last batch of packages
pacman -S "${reboot_pkglist[@]}" 
# Check for
# pkglist from ext_backup
# audio drivers

# Disable TTY clearing at boot
mkdir -p /etc/systemd/system/getty@tty1.service.d
cat <<EOF >> /etc/systemd/system/getty@tty1.service.d/noclear.conf
[Service]
TTYVTDisallocate=no
EOF

# Enable screen timout
cat <<EOF >> /etc/systemd/system/getty@tty1.service.d/blankscreen.conf
[Service]
ExecStartPost=-/usr/bin/setterm --blank 5
EOF

# Add post installation hooks
# Periodic TRIM
# Systemd services & timers
# Enable AUR & unofficial repos
# Login manager

# Congrats, all done!
