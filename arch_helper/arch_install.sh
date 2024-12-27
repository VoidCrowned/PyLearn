#!/usr/bin/env bash


set -euo pipefail

# Source the handler first so we have logging and error handling ready
source ./tools.sh
source ./log_handler.sh
source ./main.sh
source ./precheck.sh
source ./preconfig.sh
source ./test.sh

show_help() {
    echo " Usage: arch_install.sh [OPTIONS]"
    echo " -h, --help                  Show this help message"
    echo ""
    echo " -c, --config                Run 'preconfig.sh'"
    echo " -d, --dry-run               Run it all, but don't actually apply anything"
    echo " -f, --full-run              Run the full installation"
    echo " -p, --precheck              Run 'precheck.sh'"
    echo " -t, --test                  Run 'test.sh'"
    echo " -v, --verbose               Enable verbose logging"
    echo ""
    echo " Suggested: -p; -dc; -c; -df; -f"
    # Add more as needed
}

CONFIG=false
DRY=false
FULL=false
PRECHECK=false
TEST=false
VERBOSE=false

# Parse command-line arguments
while (( "$#" )); do
    case "$1" in
        --help)
            show_help
            exit 0
            ;;
        --config)
            CONFIG=true
            ;;
        --dry-run)
            DRY=true
            ;;
        --full-run)
            FULL=true
            ;;
        --precheck)
            PRECHECK=true
            ;;
        --test)
            TEST=true
            ;;
        --verbose)
            VERBOSE=true
            ;;
        # Handle combined short options
        -*)
            # Remove the leading '-' and iterate over each character
            opts="${1#-}"
            for (( i=0; i<${#opts}; i++ )); do
                opt="${opts:i:1}"
                case "$opt" in
                    h)
                        show_help
                        exit 0
                        ;;
                    c)
                        CONFIG=true
                        ;;
                    d)
                        DRY=true
                        ;;
                    f)
                        FULL=true
                        ;;
                    p)
                        PRECHECK=true
                        ;;
                    t)
                        TEST=true
                        ;;
                    v)
                        VERBOSE=true
                        ;;
                    *)
                        log_error "Unknown option: -$opt"
                        show_help
                        exit 1
                        ;;
                esac
            done
            ;;
        *)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
    shift
done


# Run the requested option
if [[ "$CONFIG" = true ]]; then
    log_info "Running pre-config..."
    run_preconfig # from preconfig.sh
fi

if [[ "$DRY" = true ]]; then
    log_info "Running dry..."
    run_dry # from TODO
fi

if [[ "$FULL" = true ]]; then
    log_info "Starting the full Arch installation..."
    run_main_install # from main.sh
fi

if [[ "$PRECHECK" = true ]]; then
    log_info "Running system pre-checks..."
    run_precheck # from precheck.sh
fi

if [[ "$TEST" = true ]]; then
    log_info "Running 'arch_test.sh'..."
    run_test # from test.sh
fi

if [[ "$VERBOSE" = true ]]; then
    enable_verbose_logging
fi
