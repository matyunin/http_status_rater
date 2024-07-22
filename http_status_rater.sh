#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <URL> <request_count>"
    exit 1
fi

URL=$1
COUNT=$2

# ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print a horizontal line
print_line() {
    printf '+----+--------+-------+------------------------+------------------+\n'
}

# Print table header
print_header() {
    print_line
    printf "| %-2s | %-6s | %-5s | %-22s | %-16s |\n" "##" "Status" "Proto" "Server" "X-Powered-By"
    print_line
}

# Function to color status code
color_status() {
    local status=$1
    if [[ $status == 200 ]]; then
        echo -n "$GREEN"
    elif [[ $status =~ ^3[0-9]{2}$ ]]; then
        echo -n "$YELLOW"
    elif [[ $status =~ ^[45][0-9]{2}$ ]]; then
        echo -n "$RED"
    else
        echo -n "$NC"
    fi
}

# Initialize variables to store status codes
status_codes=""

# Print table header
print_header

# Main loop to make requests
for i in $(seq 1 $COUNT); do
    # Make curl request and capture headers
    response=$(curl -sI "$URL")
    
    # Extract required information
    status=$(echo "$response" | grep -E "^HTTP/" | awk '{print $2}')
    proto=$(echo "$response" | grep -E "^HTTP/" | awk '{print $1}' | cut -d'/' -f2)
    server=$(echo "$response" | grep -i "^Server:" | sed 's/^Server: *//I' | tr -d '\r')
    powered_by=$(echo "$response" | grep -i "^X-Powered-By:" | sed 's/^X-Powered-By: *//I' | tr -d '\r')

    # Set placeholders for empty fields
    server=${server:-"N/A"}
    powered_by=${powered_by:-"N/A"}

    # Truncate long fields
    server=$(echo "$server" | cut -c 1-22)
    powered_by=$(echo "$powered_by" | cut -c 1-16)

    # Print table row with colored status
    status_color=$(color_status "$status")
    printf "| %2d | ${status_color}%-6s${NC} | %-5s | %-22s | %-16s |\n" $i "$status" "$proto" "$server" "$powered_by"

    # Store status codes
    status_codes="$status_codes $status"
done

# Print table footer
print_line

# Calculate and print percentages
echo "Summary:"
for status in $(echo "$status_codes" | tr ' ' '\n' | sort -u); do
    count=$(echo "$status_codes" | tr ' ' '\n' | grep -c "^$status$")
    percentage=$(awk "BEGIN {printf \"%.2f\", $count/$COUNT*100}")
    status_color=$(color_status "$status")
    echo -e "Status ${status_color}$status${NC}: $percentage%"
done

# Print full headers for debugging
echo -e "\nFull Headers (for debugging):"
curl -sI "$URL"
