#!/bin/bash
#
# Server Preparation Script
# This script prepares the server for deployment by creating directories,
# backing up existing containers, and cleaning up old resources.
#

set -e # Exit on any error

# Default values
CONTAINER_NAME=${CONTAINER_NAME:-"stellarpossible-app"}
IMAGE_NAME=${IMAGE_NAME:-"stellarpossible-nuxt"}
DEPLOY_PATH=${DEPLOY_PATH:-"/var/www/stellarpossible.com"}
APP_DIR=${APP_DIR:-"nuxt-app"}

# Print colorful messages
print_info() {
  echo -e "\033[36m🛠️ [PREPARE] $1\033[0m"
}

print_success() {
  echo -e "\033[32m✅ [PREPARE] $1\033[0m"
}

print_warning() {
  echo -e "\033[33m⚠️ [PREPARE] $1\033[0m"
}

print_error() {
  echo -e "\033[31m❌ [PREPARE] $1\033[0m"
  return 1  # Don't exit the script, just return error
}

# Check if we're running on the server
print_info "Running server preparation script..."
print_info "Deployment path: $DEPLOY_PATH"
print_info "Container name: $CONTAINER_NAME"

# Check that we have Docker
if ! command -v docker &>/dev/null; then
  print_error "Docker is not installed or not available to this user!"
  exit 1
fi

# Check Docker socket permissions
print_info "Checking Docker permissions..."
if [ ! -w /var/run/docker.sock ] && [ -e /var/run/docker.sock ]; then
  print_warning "Docker socket permission issue detected. Using alternative approach..."
  
  # First try if docker works with sudo without password (CI environment)
  if sudo -n docker info >/dev/null 2>&1; then
    print_info "Using sudo for Docker commands (non-interactive mode)..."
    DOCKER_CMD="sudo docker"
  # For non-CI environments where we can ask for a password
  elif [ -t 0 ] && command -v sudo >/dev/null 2>&1; then
    print_info "Terminal detected, attempting to use sudo with password..."
    if sudo docker info >/dev/null 2>&1; then
      DOCKER_CMD="sudo docker"
    else
      print_error "Cannot use sudo with Docker. Please run with proper permissions."
      exit 1
    fi
  else
    print_warning "Non-interactive environment detected, cannot use sudo with password..."
    print_warning "Trying Docker commands without sudo. This may fail if permissions aren't correct."
    DOCKER_CMD="docker"
  fi
else
  # Docker socket is accessible
  print_info "Docker socket is accessible, using standard Docker commands"
  DOCKER_CMD="docker"
fi

# Export the Docker command for use in the rest of the script
export DOCKER_CMD

# Create deployment directory structure
print_info "Creating deployment directory structure..."
if ! mkdir -p "$DEPLOY_PATH/$APP_DIR"; then
  print_error "Failed to create deployment directory structure!"
  exit 1
fi

# Navigate to deployment directory
print_info "Navigating to deployment directory..."
cd "$DEPLOY_PATH/$APP_DIR" || {
  print_error "Failed to navigate to deployment directory!"
  exit 1
}

# Check if container exists and back it up
print_info "Checking for existing container..."
if $DOCKER_CMD ps -a -q -f "name=$CONTAINER_NAME" | grep -q .; then
  print_info "Found existing container $CONTAINER_NAME"
  
  # Check if container is running
  if $DOCKER_CMD ps -q -f "name=$CONTAINER_NAME" | grep -q .; then
    print_info "Container is running, creating backup..."
    BACKUP_TAG="backup-$(date +%Y%m%d-%H%M%S)"
    
    if $DOCKER_CMD commit "$CONTAINER_NAME" "$IMAGE_NAME:$BACKUP_TAG"; then
      print_success "Created backup image $IMAGE_NAME:$BACKUP_TAG"
    else
      print_warning "Failed to create backup image, but continuing..."
    fi
  else
    print_warning "Container exists but is not running, skipping backup..."
  fi
  
  # Stop and remove container
  print_info "Stopping and removing container $CONTAINER_NAME..."
  $DOCKER_CMD stop "$CONTAINER_NAME" 2>/dev/null || print_warning "Container already stopped"
  $DOCKER_CMD rm "$CONTAINER_NAME" 2>/dev/null || print_warning "Container removal failed, will force remove"
  $DOCKER_CMD rm -f "$CONTAINER_NAME" 2>/dev/null || print_warning "Force removal failed, continuing anyway..."
else
  print_info "No existing container found, proceeding with fresh deployment..."
fi

# Clean up old backup images (keep only the last 3)
print_info "Checking for old backup images..."

# Get backup image count
BACKUP_COUNT=$($DOCKER_CMD images "$IMAGE_NAME" --format "{{.Tag}}" | grep -c "backup" 2>/dev/null || echo "0")

if [ "$BACKUP_COUNT" -gt 0 ]; then
  print_info "Found $BACKUP_COUNT backup images"
  
  if [ "$BACKUP_COUNT" -gt 3 ]; then
    print_info "Keeping the newest 3 backups, removing the rest..."
    
    # List all backup images, sort by date (newest first), skip first 3, remove the rest
    IMAGES_TO_REMOVE=$($DOCKER_CMD images "$IMAGE_NAME" --format "{{.Repository}}:{{.Tag}}" | 
                      grep "backup" | sort -r | tail -n +4)
    
    if [ -n "$IMAGES_TO_REMOVE" ]; then
      echo "$IMAGES_TO_REMOVE" | xargs -r $DOCKER_CMD rmi 2>/dev/null || 
        print_warning "Some images could not be removed, they might be in use"
    fi
  else
    print_info "Only $BACKUP_COUNT backup images found, no cleanup needed"
  fi
else
  print_info "No backup images found"
fi

print_success "Server preparation completed successfully!"