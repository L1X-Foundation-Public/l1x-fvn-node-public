#!/bin/bash

# Check if the script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root. Please use sudo."
    exit 1
fi

# Get the absolute path to the autoMaintain.sh script
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
AUTO_MAINTAIN_SCRIPT="$SCRIPT_DIR/autoMaintain.sh"

# Crontab entry to run autoMaintain.sh every 30 minutes
CRON_JOB="*/30 * * * * $AUTO_MAINTAIN_SCRIPT"

# Function to check if a crontab entry already exists
crontab_entry_exists() {
    crontab -l | grep -F "$AUTO_MAINTAIN_SCRIPT" &> /dev/null
}

# Function to add the crontab entry if it doesn't already exist
add_crontab_entry() {
    if crontab_entry_exists; then
        echo "Crontab entry already exists."
    else
        # Add the crontab entry
        (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
        echo "Crontab entry added."
    fi
}

# Run the function to add the crontab entry
add_crontab_entry
