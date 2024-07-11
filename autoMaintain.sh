#!/bin/bash


DOCKER_COMPOSE=false
BLOCK_DIFF_THRESHOLD=1000

# Detect the operating system
OS=$(uname)
if [ "$OS" = "Darwin" ]; then
  PLATFORM="macOS"
elif [ "$OS" = "Linux" ]; then
  PLATFORM="Linux"
else
  echo "Unsupported OS: $OS"
  exit 1
fi

echo "Detected OS: $PLATFORM"

# Check for both possible command names
if command -v docker-compose &>/dev/null; then
  DOCKER_COMPOSE="docker-compose"
elif command -v docker compose &>/dev/null; then
  DOCKER_COMPOSE="docker compose"
fi

# Error if Docker Compose is not installed
if [ "$DOCKER_COMPOSE" = false ]; then
  echo "Error: Docker Compose is not installed."
  exit 1
fi

# Determine the directory where the script is located
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Read configuration from config.toml located in the script's directory
CONFIG_FILE="$SCRIPT_DIR/config.toml"

# Extract postgres_username from config.toml
PSQL_USER=$(grep 'postgres_username' "$CONFIG_FILE" | awk -F' = ' '{gsub(/"/, "", $2); print $2}')

# Docker and database details
DOCKER_CONTAINER="v2_core_db"
PSQL_DB="l1x"
PSQL_QUERY="SELECT block_number FROM block_meta_info WHERE block_executed = true ORDER BY block_number DESC LIMIT 1;"

# Function to fetch the latest executed block number from the local database
fetch_latest_local_block_executed() {
    docker exec -i $DOCKER_CONTAINER psql -U $PSQL_USER -d $PSQL_DB -c "$PSQL_QUERY" | \
    awk 'NR==3 {gsub(/[ \t]+/, "", $0); print $1}'
}

# Function to fetch the current mainnet head_block_number
fetch_head_block_number() {
    response=$(curl -s --max-time 10 \
        -H "Content-Type: application/json" \
        --data '{
          "jsonrpc": "2.0",
          "id": 1,
          "method": "l1x_getChainState",
          "params": {
            "request": {}
          }
        }' \
        "https://v2-mainnet-rpc.l1x.foundation")

    # Extract head_block_number from the response using awk
    echo "$response" | awk -F'"head_block_number":"' '{print $2}' | awk -F'"' '{print $1}'
}

# Loop to continuously monitor the latest blocks

echo -e "\n\nMonitoring latest blocks..."

latest_block=$(fetch_latest_local_block_executed)
current_head_block_number=$(fetch_head_block_number)

echo "Latest Block: $latest_block"
echo "Head Block Number: $current_head_block_number"

if [ $((current_head_block_number - latest_block)) -gt $BLOCK_DIFF_THRESHOLD ]; then

    $DOCKER_COMPOSE -f $SCRIPT_DIR/docker/docker-compose.yml down

    # Remove the volume associated with v2_core_db
    VOLUME_NAME=$(docker volume ls -q -f "name=v2_core_db")
    if [ -n "$VOLUME_NAME" ]; then
        echo "Removing volume $VOLUME_NAME..."
        docker volume rm "$VOLUME_NAME"
    else
        echo "No volume found for v2_core_db."
    fi

    # Remove the chain_data directory
    CHAIN_DATA_DIR="./chain_data"
    if [ -d "$CHAIN_DATA_DIR" ]; then
        echo "Removing directory $CHAIN_DATA_DIR..."
        rm -rf "$CHAIN_DATA_DIR"
    else
        echo "No directory found for chain_data."
    fi

    echo "All specified containers have been stopped and removed, the volume has been deleted, and the directory chain_data has been removed!"

    rm -rf $SCRIPT_DIR/l1x-db
    $SCRIPT_DIR/startL1X.sh

fi