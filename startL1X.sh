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

# Copy the appropriate directory based on the detected OS
# if [ "$PLATFORM" = "macOS" ]; then
#   cp -r bin/l1x-core-mac bin/l1x-core
#   echo "Copied l1x-core-mac to l1x-core"
# elif [ "$PLATFORM" = "Linux" ]; then
#   cp -r bin/l1x-core-linux bin/l1x-core
#   echo "Copied l1x-core-linux to l1x-core"
# fi

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
# Check if v2_core_db container is already running
if ! docker ps -f "name=v2_core_db" --format '{{.Names}}' | grep -q "v2_core_db"; then
    echo "v2_core_db is not running. Starting it..."
    $DOCKER_COMPOSE -f ./docker/docker-compose.yml up -d v2_core_db

    echo "Waiting for 30 seconds before starting v2_core_server"
    sleep 30
else
    echo "v2_core_db is already running."
fi

# exit
# Check if v2_core_server container is already running
if docker ps -f "name=v2_core_server" --format '{{.Names}}' | grep -q "v2_core_server"; then
    echo "v2_core_server is already running. Stopping it..."
    $DOCKER_COMPOSE -f ./docker/docker-compose.yml down v2_core_server
fi

$DOCKER_COMPOSE -f ./docker/docker-compose.yml up -d --build v2_core_server

echo "All containers are up!"
