#!/bin/bash
#
# Application Deployment Script
# This script deploys the Docker container to the server.
#

set -e # Exit on any error

# Default values
CONTAINER_NAME=${CONTAINER_NAME:-"stellarpossible-app"}
IMAGE_NAME=${IMAGE_NAME:-"stellarpossible-nuxt"}
TAG=${TAG:-"latest"}
DEPLOY_PATH=${DEPLOY_PATH:-"/var/www/stellarpossible.com"}
APP_DIR=${APP_DIR:-"nuxt-app"}
TAR_FILE=${TAR_FILE:-""}

# Environment variables
WP_USER=${WP_USER:-"admin"}
WP_APP_PASSWORD=${WP_APP_PASSWORD:-""}
WP_GRAPHQL_ENDPOINT=${WP_GRAPHQL_ENDPOINT:-"https://stellarpossible.com/cms/graphql"}
WP_REST_ENDPOINT=${WP_REST_ENDPOINT:-"https://stellarpossible.com/cms/wp-json"}
WP_API_URL=${WP_API_URL:-"https://stellarpossible.com/cms"}
USE_JWT=${USE_JWT:-"false"}
JWT_SECRET=${JWT_SECRET:-""}
ADMIN_EMAIL=${ADMIN_EMAIL:-""}

# Print colorful messages
print_info() {
  echo -e "\033[36m🚀 [DEPLOY] $1\033[0m"
}

print_success() {
  echo -e "\033[32m✅ [DEPLOY] $1\033[0m"
}

print_warning() {
  echo -e "\033[33m⚠️ [DEPLOY] $1\033[0m"
}

print_error() {
  echo -e "\033[31m❌ [DEPLOY] $1\033[0m"
  exit 1
}

# Navigate to deployment directory
print_info "Navigating to deployment directory $DEPLOY_PATH/$APP_DIR"
cd "$DEPLOY_PATH/$APP_DIR" || {
  print_error "Failed to navigate to deployment directory!"
}

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

# Load Docker image if a tar file is provided
if [ -n "$TAR_FILE" ] && [ -f "$TAR_FILE" ]; then
  print_info "Loading Docker image from $TAR_FILE..."
  if gunzip -c "$TAR_FILE" | $DOCKER_CMD load; then
    print_success "Docker image loaded successfully!"
  else
    print_error "Failed to load Docker image!"
  fi
fi

# Create environment file
print_info "Creating environment file..."
cat > .env << EOF
# WordPress Configuration
WP_USER=$WP_USER
WP_APP_PASSWORD=$WP_APP_PASSWORD
WP_GRAPHQL_ENDPOINT=$WP_GRAPHQL_ENDPOINT
WP_REST_ENDPOINT=$WP_REST_ENDPOINT
WP_API_URL=$WP_API_URL

# JWT Configuration
USE_JWT=$USE_JWT
JWT_SECRET=$JWT_SECRET

# Application Configuration
NODE_ENV=production
NITRO_PORT=3000
HOST=0.0.0.0

# Admin Configuration
ADMIN_EMAIL=$ADMIN_EMAIL
EOF

# Create logs directory with proper permissions
print_info "Creating logs directory..."
mkdir -p logs
chmod 755 logs
chown -R "$(id -u):$(id -g)" logs

# Start the container
print_info "Starting container $CONTAINER_NAME..."
if $DOCKER_CMD run -d \
  --name "$CONTAINER_NAME" \
  --restart unless-stopped \
  -p 3000:3000 \
  --env-file .env \
  -v "$(pwd)/logs:/app/logs" \
  "$IMAGE_NAME:$TAG"; then
  
  print_success "Container started successfully!"
else
  print_error "Failed to start container!"
fi

# Verify container is running
print_info "Verifying container is running..."
sleep 5

if $DOCKER_CMD ps -q -f "name=$CONTAINER_NAME" | grep -q .; then
  print_success "Container is confirmed running!"
  $DOCKER_CMD ps -f "name=$CONTAINER_NAME"
else
  print_error "Container is not running! Showing logs:"
  $DOCKER_CMD logs "$CONTAINER_NAME"
fi

# Clean up tar file if it exists
if [ -n "$TAR_FILE" ] && [ -f "$TAR_FILE" ]; then
  print_info "Cleaning up tar file..."
  rm -f "$TAR_FILE"
fi

print_success "Deployment completed successfully!"