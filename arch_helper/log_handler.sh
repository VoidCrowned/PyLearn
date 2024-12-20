#!/usr/bin/env bash


set -euo pipefail

# Source formatting
source ./tools.sh

# Logging settings
LOG_LEVEL="info"
VERBOSE_LOGGING=false

log_info() {
    echo -e " [ INF ] $*"
}

log_success() {
    echo -e " [ ${fgre}SUC${fstd} ] $*"
}

log_warn() {
    echo -e " [ ${fyel}WAR${fstd} ] $*" >&2
}

log_error() {
    echo -e " [ ${fred}ERR${fstd} ] $*" >&2
}

log_debug() {
    if [[ "$VERBOSE_LOGGING" = true ]]; then
        echo -e " [ ${fcya}DEB${fstd} ] $*"
    fi
}

enable_verbose_logging() {
    VERBOSE_LOGGING=true
}

# Error handling: trap on ERR/EXIT if desired
trap 'handle_exit' EXIT

handle_exit() {
    exit_code=$?
    if [[ "$exit_code" -ne 0 ]]; then
        log_error "Script exited with non-zero status: $exit_code"
        # Possibly print last executed command if you store them
    fi
    exit $exit_code
}
