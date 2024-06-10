#!/bin/bash

# Navigate to the application directory
cd /app/

# sleep infinity
# Create the data directory structure for L1X if it doesn't exist
if [ ! -d "l1x_data/l1x" ]; then
    mkdir -p l1x_data/l1x
    # Initialize the server, specifying the working directory
    ./l1x-core init -w "l1x_data/l1x"
    # Pause for 30 seconds (likely for initialization tasks to complete)
    sleep 10
    
    ./l1x-core apply_snapshot -w "l1x_data/l1x"
fi


# Check if the data directory exists
if [ -d "l1x_data/l1x" ]; then
    # Announce server startup
    echo "Starting server"

    # Start the server with RUST_LOG set to "info" for logging
    RUST_LOG=info ./l1x-core start -w "l1x_data/l1x" -t fvn
else
    echo "Error: Unable to create data directory structure."
fi