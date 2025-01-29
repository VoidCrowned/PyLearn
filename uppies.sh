#!/usr/bin/env bash

##
## Use and modify as needed.
## - VoidCrowned
##

fres='\033[0m'
fbol='\033[1m'
fgred='\033[0;31m'

set -e

# Function to print text in bold
fg_b() {
    echo -e "${fbol}$*${fres}"
}

# Function to print text in red
fg_r() {
    echo -e "${fgred}$*${fres}"
}

# Associative array for services
declare -A services
services=(
    [1]="0x0.st https://0x0.st"
    [2]="other.service https://other.service"
)

# Function to display help message
show_help() {
    echo "Usage:"
    echo -e "    $(fg_b 'uppies.sh') [service] [file]"
    echo -e "    The returned link will be copied to your clipboard.\n"
    echo "Configured services:"
    for key in $(printf "%s\n" "${!services[@]}" | sort -n); do
        service_info=(${services[$key]})
        echo -e "    $(fg_b "$key")) ${service_info[@]}"
    done
    exit 0
}

# Check if the service is provided
if [[ -z "$1" ]]; then
    show_help
    exit 1
fi

# Set the upload URL based on the specified service
if [[ -n "${services[$1]}" ]]; then
    service_info=(${services[$1]})
    URL="${service_info[1]}"
else
    echo -e "$(fg_r 'Unsupported service:') $1"
    exit 1
fi

# Check if input is piped or if it's a file provided as an argument
if [[ -t 0 ]]; then
    # No input from pipe, use the file path
    response=$(curl --silent -F "file=@$2" "$URL")
else
    # Input from pipe, use stdin
    response=$(curl --silent -F "file=@-" "$URL")
fi

# Print the response & copy it to clipboard
echo "$response"
echo -n "$response" | xclip -selection clipboard
