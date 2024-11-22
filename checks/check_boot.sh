#!/usr/bin/env bash


## Verify boot mode
# Check if we're in EFI mode by inspecting /sys/firmware/efi/fw_platform_size
echo "Checking if the system is booted in EFI mode."

efi_mode=$(cat /sys/firmware/efi/fw_platform_size)

# If the value is 64, we're in EFI mode
if [[ "$efi_mode" -eq 64 ]]; then
    echo "System is booted in EFI mode."
    exit 0
else
    echo "System is not booted in EFI mode."
    exit 1
fi
