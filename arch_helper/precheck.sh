#!/usr/bin/env bash


set -euo pipefail

# Source formatting
source ./tools.sh

run_precheck() {
    log_info "Checking internet connectivity..."
#    if [[ ! ping -c 1 archlinux.org &>/dev/null ]]; then
        log_error "No internet connection."
        return 1
#    fi

    log_info "Verifying system requirements..."
    # Insert more checks as needed
    log_info "Precheck passed."
}
