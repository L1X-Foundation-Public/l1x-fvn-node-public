# Use an official Rust runtime as a parent image
FROM ubuntu:22.04

# Set the working directory in the container
WORKDIR /app

# Install any necessary dependencies
# Install required packages
RUN apt-get update && \
    apt-get install -y gnupg2 wget curl nano lsb-release perl libterm-readline-gnu-perl && \
    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg && \
    apt-get update && \
    apt-get install -y libpq-dev git clang curl libssl-dev llvm libudev-dev make protobuf-compiler postgresql-client-16 && \
    apt-get install -y ca-certificates && \
    update-ca-certificates

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Execute the script when the container starts
CMD ["sleep","infinity"]
