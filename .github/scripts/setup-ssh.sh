#!/bin/bash
#
# SSH Setup Script for GitHub Actions
# This script sets up SSH keys for secure server connections.
#

set -e # Exit on any error

# Print colorful messages
print_info() {
  echo -e "\033[36m🔑 [SSH SETUP] $1\033[0m"
}

print_success() {
  echo -e "\033[32m✅ [SSH SETUP] $1\033[0m"
}

print_error() {
  echo -e "\033[31m❌ [SSH SETUP] $1\033[0m"
  exit 1
}

# Check for required environment variables
if [ -z "$SSH_PRIVATE_KEY" ]; then
  print_error "SSH_PRIVATE_KEY environment variable is not set!"
fi

if [ -z "$SERVER_HOST" ]; then
  print_error "SERVER_HOST environment variable is not set!"
fi

if [ -z "$SERVER_USER" ]; then
  print_error "SERVER_USER environment variable is not set!"
fi

print_info "Setting up SSH keys..."

# Create SSH directory if it doesn't exist
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Write SSH private key to file
echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

# Set up known_hosts
if [ -n "$SSH_HOST_KEY" ]; then
  print_info "Using provided SSH host key"
  echo "$SERVER_HOST $SSH_HOST_KEY" >> ~/.ssh/known_hosts
else
  print_info "No SSH_HOST_KEY provided, using StrictHostKeyChecking=accept-new"
  echo "StrictHostKeyChecking accept-new" > ~/.ssh/config
  chmod 644 ~/.ssh/config
fi

# Test SSH connection
print_info "Testing SSH connection to $SERVER_USER@$SERVER_HOST..."
if ssh -o ConnectTimeout=10 $SERVER_USER@$SERVER_HOST "echo '🔑 SSH connection successful!'"; then
  print_success "SSH connection established successfully!"
else
  print_error "Failed to establish SSH connection. Please check your SSH key and server details."
fi

# Print SSH key fingerprint for verification
print_info "SSH key fingerprint:"
ssh-keygen -lf ~/.ssh/id_rsa

print_success "SSH setup completed!"