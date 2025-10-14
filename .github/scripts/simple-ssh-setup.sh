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

print_warning() {
  echo -e "\033[33m⚠️ [SSH SETUP] $1\033[0m"
}

print_error() {
  echo -e "\033[31m❌ [SSH SETUP] $1\033[0m"
  exit 1
}

print_info "Setting up SSH keys for GitHub Actions..."

# Check for required environment variables
if [ -z "$SSH_PRIVATE_KEY" ]; then
  print_error "SSH_PRIVATE_KEY environment variable is not set!"
fi

if [ -z "$VPS_SERVER" ]; then
  print_error "VPS_SERVER environment variable is not set!"
fi

if [ -z "$VPS_USERNAME" ]; then
  print_error "VPS_USERNAME environment variable is not set!"
fi

# Create SSH directory if it doesn't exist
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Write SSH private key to file
print_info "Writing SSH private key to file..."
echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

# Create SSH config with disable strict host key checking
print_info "Creating SSH config..."
cat > ~/.ssh/config << EOF
Host *
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
  LogLevel ERROR
EOF
chmod 644 ~/.ssh/config

# If SSH_HOST_KEY is provided, use it
if [ -n "$SSH_HOST_KEY" ]; then
  print_info "Adding provided SSH host key to known_hosts..."
  echo "$VPS_SERVER $SSH_HOST_KEY" >> ~/.ssh/known_hosts
  chmod 644 ~/.ssh/known_hosts
fi

# Print SSH key information
print_info "SSH key fingerprint:"
ssh-keygen -lf ~/.ssh/id_rsa || print_warning "Could not get key fingerprint"

# Test SSH connection
print_info "Testing SSH connection to $VPS_USERNAME@$VPS_SERVER..."
if ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no $VPS_USERNAME@$VPS_SERVER "echo '🔑 SSH connection successful!'"; then
  print_success "SSH connection established successfully!"
else
  print_error "Failed to establish SSH connection. Please check your SSH key and server details."
fi

print_success "SSH setup completed!"