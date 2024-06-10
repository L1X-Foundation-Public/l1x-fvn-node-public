#!/bin/sh

# Generate a 6-character random user and a 16-character random password
user=$(LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 6)
password=$(LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 16)

# Replace the placeholder in the config.toml.template file and create config.toml
sed -e "s/<PLACEHOLDER_POSTGRES_USER>/$user/g" -e "s/<PLACEHOLDER_POSTGRES_PASSWORD>/$password/g" config.toml.template > config.toml

# Replace the placeholders in the docker-compose.yml.template file and create docker-compose.yml
sed -e "s/<PLACEHOLDER_POSTGRES_USER>/$user/g" -e "s/<PLACEHOLDER_POSTGRES_PASS>/$password/g" docker/docker-compose.yml.template > docker/docker-compose.yml

# Create DB Directory 
mkdir -p l1x-db/data

# Output the generated user and password
echo "Generated User: $user"
echo "Generated Password: $password"
echo "The placeholders in config.toml.template have been replaced and saved as config.toml."
echo "The placeholders in docker-compose.yml.template have been replaced and saved as docker-compose.yml."
