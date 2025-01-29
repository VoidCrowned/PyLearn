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
fgbol() {
    echo -e "${fbol}$*${fres}"
}

# Function to print text in red
fgred() {
    echo -e "${fgred}$*${fres}"
}

# Services
serv_01=("0x0.st" "https://0x0.st")
#serv_01=("0x0.st" "https://0x0.st")

# Function to display help message
show_help() {
    echo "Usage:"
    echo -e "    $(fgbol 'uppies.sh') [service] [file]"
#    echo -e "    $(fgbol 'uppies.sh') h, -h, help, --help"
    echo "    The returned link will be copied to your clipboard."
    echo ""
    echo "Configured services:"
    echo -e "    $(fgbol '1')) "${serv_01[0]}""
    exit 0
}

# Check for help options
#if [[ "$1" == "h" || "$1" == "-h" || "$1" == "help" || "$1" == "--help" ]]; then
#    show_help
#    exit 0
#fi

# Check if the service is provided
if [[ -z "$1" ]]; then
    show_help
    # echo "2) placeholder"
    # echo "3) placeholder"
    exit 1
fi

# Set the upload URL based on the specified service
if [[ "$1" == "1" ]]; then
    URL=""${serv_01[1]}""
    # elif [[ "$1" == "2" ]]; then
    # URL=""
else
    echo -e "$(fgred 'Unsupported service:') $1"
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

# Print the response and copy it to clipboard
echo "$response"
echo -n "$response" | xclip -selection clipboard
