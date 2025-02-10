#!/usr/bin/env bash

##
## Use and modify as needed.
## - VoidCrowned
##

source 00_settings.sh
source 99_styles.sh

check_priv
set +ex

# Pacstrap base & additional packages
pacstrap -K /mnt "${base_pkglist[@]}"

# Generate the filesystem tab & copy it over
genfstab -U /mnt >> /mnt/etc/fstab

# Time to chroot with
# arch-chroot /mnt
# Proceed with 03_post_chroot.sh
