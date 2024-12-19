#!/usr/bin/env bash


set -euo pipefail

# Source formatting
source ./arch_tools.sh

run_main_install() {
    # Example workflow:
    partition_disks
    mount_filesystems
    bootstrap_system
    configure_system
    setup_user
    finalise_install
}

partition_disks() {
    # Just an example
    log_info "Partitioning disks..."
    # If something fails:
    #    log_error "Failed to partition disks"
    #    return 1
}

mount_filesystems() {
    log_info "Mounting filesystems..."
}

bootstrap_system() {
    log_info "Installing base system..."
    # e.g., pacstrap command here
}

configure_system() {
    log_info "Configuring system..."
}

setup_user() {
    # Here you might need user input:
    read -p "Enter a username: " USERNAME
    # Create user accounts, set passwords, etc.
}

finalize_install() {
    log_info "Installation complete!"
}
