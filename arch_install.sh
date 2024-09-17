#!/usr/bin/env bash


## First we're going to need a basic structure
## Verify boot mode
#    - cat /sys/firmware/efi/fw_platform_size
#    - print && check return value
#    - confirm result

## Set kbd
#    - list available kb layouts
#    - offer them as options to pick, either as number or by name
#    - with loadkeys

## Set font
#    - list available fonts
#    - same as above, but with a grep filter added
#    - with setfont

## Set internet connection
#    - ip link
#    - check with `ping`

## Set date & time
#    - `timedatectl`

## Partition disks
#    - call `cfdisk`, then return
#    - summarise partition table
#    - `lsblk`

## Format disks
#    - `lsblk`
#    - `mkfs`
#    - swap y/n
#    - `mkswap`

## Mount it all
#    - `mount --mkdir`
#    - `swapon`

## Installation
#    - `pacstrap -K /mnt base linux linux-firmware`

## Fstab
#    - watch proper boot load order

## Chroot

## Date & Time

## Localisation

## Network config
#    - Hostname

## Initramfs

## User setup

## su/sudo

## Bootloader

## Reboot
