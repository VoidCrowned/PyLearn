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
    echo " -p, --precheck              Run 'precheck.sh'"
    echo " -c, --config                Run 'preconfig.sh'"
    echo " -r, --run                   Run the full installation"
    echo " -t, --test                  Run 'test.sh'"
    echo " -v, --verbose               Enable verbose logging"
    # Add more as needed
}

PRECHECK=false
CONFIG=false
INSTALL=false
TEST=false
VERBOSE=false

# Parse command-line arguments
while (( "$#" )); do
    case "$1" in
        --help)
            show_help
            exit 0
            ;;
        --precheck)
            PRECHECK=true
            ;;
        --config)
            CONFIG=true
            ;;
        --run)
            INSTALL=true
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
                    p)
                        PRECHECK=true
                        ;;
                    c)
                        CONFIG=true
                        ;;
                    r)
                        INSTALL=true
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

#while (( "$#" )); do
#    case "$1" in
#        -h|--help)
#            show_help
#            exit 0
#            ;;
#        -p|--precheck)
#            PRECHECK=true
#            ;;
#        -c|--config)
#            CONFIG=true
#            ;;
#        -r|--run)
#            INSTALL=true
#            ;;
#        -t|--test)
#            TEST=true
#            ;;
#        -v|--verbose)
#            VERBOSE=true
#            ;;
#        *)
#            log_error "Unknown option: $1"
#            show_help
#            exit 1
#            ;;
#    esac
#    shift
#done

# If verbose is enabled, tell the handler
if [[ "$VERBOSE" = true ]]; then
    enable_verbose_logging
fi

# Run pre-checks if requested
if [[ "$PRECHECK" = true ]]; then
    log_info "Running system pre-checks..."
    run_precheck # from precheck.sh
fi

# Run pre-config if requested
if [[ "$CONFIG" = true ]]; then
    log_info "Running pre-config..."
    run_preconfig # from preconfig.sh
fi

# Run the main installation if requested
if [[ "$INSTALL" = true ]]; then
    log_info "Starting the full Arch installation..."
    run_main_install # from main.sh
fi

# Run 'arch_test.sh' if requested
if [[ "$TEST" = true ]]; then
    log_info "Running 'arch_test.sh'..."
    run_test # from test.sh
fi

