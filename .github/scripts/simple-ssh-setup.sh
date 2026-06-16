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

# Write SSH private key (preserve newlines; strip CR from Windows paste; neutral filename)
DEPLOY_KEY="$HOME/.ssh/id_deploy"
print_info "Writing SSH private key to file..."
printf '%s\n' "$SSH_PRIVATE_KEY" | tr -d '\r' > "$DEPLOY_KEY"
chmod 600 "$DEPLOY_KEY"

# Prepare known_hosts before SSH config so pinned host keys take effect
touch ~/.ssh/known_hosts
chmod 644 ~/.ssh/known_hosts
if [ -n "$SSH_HOST_KEY" ]; then
  print_info "Adding provided SSH host key to known_hosts..."
  echo "$VPS_SERVER $SSH_HOST_KEY" >> ~/.ssh/known_hosts
fi

if [ -n "$SSH_HOST_KEY" ]; then
  HOST_KEY_POLICY=yes
else
  HOST_KEY_POLICY=accept-new
fi

# Create SSH config — IdentitiesOnly avoids agent/other keys masking deploy key failures
print_info "Creating SSH config..."
cat > ~/.ssh/config << EOF
Host ${VPS_SERVER}
  HostName ${VPS_SERVER}
  User ${VPS_USERNAME}
  IdentityFile ${DEPLOY_KEY}
  IdentitiesOnly yes
  StrictHostKeyChecking ${HOST_KEY_POLICY}
  UserKnownHostsFile ~/.ssh/known_hosts
  LogLevel ERROR

Host *
  StrictHostKeyChecking accept-new
  UserKnownHostsFile ~/.ssh/known_hosts
  LogLevel ERROR
EOF
chmod 644 ~/.ssh/config

# Print SSH key information (sanity check that file parses)
print_info "SSH key fingerprint:"
ssh-keygen -lf "$DEPLOY_KEY" || print_warning "Could not get key fingerprint"

# Test SSH connection (explicit host block picks IdentityFile + IdentitiesOnly from config)
print_info "Testing SSH connection to $VPS_USERNAME@$VPS_SERVER..."
SSH_OPTS=(-o ConnectTimeout=15 BatchMode=yes)
if [ "${SSH_DEBUG:-}" = "1" ]; then
  SSH_OPTS+=(-vvv)
fi
if ssh "${SSH_OPTS[@]}" "$VPS_SERVER" "echo '🔑 SSH connection successful!'"; then
  print_success "SSH connection established successfully!"
else
  print_error "Failed to establish SSH connection. Please check your SSH key and server details."
fi

print_success "SSH setup completed!"