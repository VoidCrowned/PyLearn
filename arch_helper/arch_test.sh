#!/usr/bin/env bash


set -euo pipefail

# Source formatting
source ./arch_tools.sh

run_test() {
    log_info "This is a 'log_info level' message."
    log_warn "This is a 'log_warn level' message."
    log_error "This is a 'log_error level' message."
    log_debug "This is a 'log_debug level' message."
}
