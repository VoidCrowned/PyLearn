#!/usr/bin/env bash

##
## Use and modify as needed.
## - VoidCrowned
##

# Settings
kbm="dvorak"
font="Lat2-Terminus16"
timezone="Europe/Berlin"
h_name="sovereign_arch"
u_name="void"
mirror_opts="-c EU -p https --age 6 --fastest 10 --sort rate"
# Base installation
base_pkglist=("base" "linux" "linux-firmware" "intel-ucode" "sudo" "networkmanager" "git" "fsck" "man-db" "man-pages" "texinfo" "util-linux" "pkgstats")
# Install after chroot
post_pkglist=("lua" "neovim" "mlocate" "tmux" "nvidia" "xorg" "openbox" "wayland" "hyprland")
# Install remaining packages
reboot_pkglist=("gpick" "libnotify" "rsync" "maim" "slop" "xclip" "discord" "firefox" "weechat" "mpd" "spotify" "ncmpcpp")

check_priv() {
    if [[ "$EUID" -ne 0 ]]; then
    echo -e "Run this script with ${fbol}sudo${fres} or as ${fbol}root${fres}."
    echo -e "Try again. Bailing."
    exit 1
fi
}
