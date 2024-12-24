#!/usr/bin/env bash


set -e
# Check if the service is provided
if [[ -z "$1" ]]; then
    echo "Please specify an upload service:"
    echo "1) 0x0.st"
#    echo "2) placeholder"
#    echo "3) placeholder"
    exit 1
fi

# Set the upload URL based on the specified service
if [[ "$1" == "1" ]]; then
    URL="https://0x0.st"
#elif [[ "$1" == "2" ]]; then
#    URL=""
else
    echo "Unsupported service: $1"
    exit 1
fi

# Check if input is piped or if it's a file provided as an argument
if [[ -t 0 ]]; then
    # No input from pipe, use the file path
    curl -F "file=@$2" "$URL"
else
    # Input from pipe, use stdin
    curl -F "file=@-" "$URL"
fi
