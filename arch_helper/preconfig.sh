#!/usr/bin/env bash


set -euo pipefail

# Source formatting
source ./tools.sh

run_preconfig() {
# List of scripts to run
#scripts=("check_kbm.sh" "check_font.sh" "check_boot.sh")
#for script in "${scripts[@]}"; do
#    echo -e "Running $script."
#    ./checks/$script
#    if [[ $? -ne 0 ]]; then
#        echo -e "$script failed. Exiting."
#        exit 1
#    fi
#done
    log_info "Checking internet connectivity..."
#    if [[ ! ping -c 1 archlinux.org &>/dev/null ]]; then
        log_error "No internet connection."
        return 1
#    fi
# set_pacman_settings
# check_efi
# check_font
# check_kbm
    log_info "Verifying system requirements..."
    # Insert more checks as needed
    log_success "Precheck passed."
}
