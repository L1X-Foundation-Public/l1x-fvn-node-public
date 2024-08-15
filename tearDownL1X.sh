#!/bin/bash

DOCKER_COMPOSE=false

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

# Prompt for user confirmation with red color and exclamatory mark
RED='\033[0;31m'
NC='\033[0m' # No Color
echo -e "${RED}!!! This operation will stop the v2_core_server and v2_core_db containers, remove the v2_core_db volume, and delete the local chain_data directory !!!${NC}"
read -p "Are you sure you want to proceed? (y/n) " -n 1 -r
echo    # move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Operation aborted by the user."
    exit 1
fi

$DOCKER_COMPOSE -f ./docker/docker-compose.yml down

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

# Remove the l1x-db directory
L1X_DB_DIR="./l1x-db"
if [ -d "$L1X_DB_DIR" ]; then
    echo "Removing directory $L1X_DB_DIR..."
    rm -rf "$L1X_DB_DIR"
else
    echo "No directory found for l1x-db."
fi

echo "All specified containers have been stopped and removed, the volume has been deleted, and the directory chain_data has been removed!"
