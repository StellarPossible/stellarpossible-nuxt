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

# Check Docker socket permissions and configure deployment approach
print_info "Checking Docker permissions..."

# Use Docker command from environment if provided, otherwise determine it
DOCKER_CMD=${DOCKER_CMD:-"docker"}
DEPLOY_METHOD=${DEPLOY_METHOD:-"docker"}

# Check if we can run docker directly
if docker info >/dev/null 2>&1; then
  print_success "Direct Docker access confirmed!"
  DOCKER_CMD="docker"
  DEPLOY_METHOD="docker"
# Check if we can run docker with sudo without password (CI environment)
elif sudo -n docker info >/dev/null 2>&1; then
  print_info "Using sudo for Docker commands (non-interactive mode)..."
  DOCKER_CMD="sudo docker"
  DEPLOY_METHOD="docker"
# Check for interactive sudo possibility
elif [ -t 0 ] && command -v sudo >/dev/null 2>&1; then
  print_info "Terminal detected, attempting to use sudo with password..."
  # This will prompt for password if needed
  if sudo docker info >/dev/null 2>&1; then
    DOCKER_CMD="sudo docker"
    DEPLOY_METHOD="docker"
  else
    print_warning "Cannot use sudo with Docker. Falling back to non-Docker deployment."
    DEPLOY_METHOD="manual"
  fi
else
  print_warning "No Docker access available. Falling back to manual deployment mode."
  DEPLOY_METHOD="manual"
fi

print_info "Deployment method: $DEPLOY_METHOD"

# Export the Docker command for use in the rest of the script
export DOCKER_CMD

# Load Docker image if a tar file is provided
if [ "$DEPLOY_METHOD" = "docker" ] && [ -n "$TAR_FILE" ] && [ -f "$TAR_FILE" ]; then
  print_info "Loading Docker image from $TAR_FILE..."
  if gunzip -c "$TAR_FILE" | $DOCKER_CMD load; then
    print_success "Docker image loaded successfully!"
  else
    print_warning "Failed to load Docker image with $DOCKER_CMD. Switching to manual deployment..."
    DEPLOY_METHOD="manual"
  fi
elif [ "$DEPLOY_METHOD" = "manual" ] && [ -n "$TAR_FILE" ] && [ -f "$TAR_FILE" ]; then
  # Extract the tar.gz contents for manual deployment
  print_info "Extracting application files from $TAR_FILE for manual deployment..."
  mkdir -p ./extracted
  if tar -xzf "$TAR_FILE" -C ./extracted; then
    print_success "Application files extracted successfully!"
  else
    print_error "Failed to extract application files!"
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

# Deploy based on determined method
if [ "$DEPLOY_METHOD" = "docker" ]; then
  # Docker-based deployment
  print_info "Starting container $CONTAINER_NAME..."
  
  # Stop and remove existing container if it exists
  if $DOCKER_CMD ps -a -q -f "name=$CONTAINER_NAME" | grep -q .; then
    print_info "Stopping and removing existing container..."
    $DOCKER_CMD stop "$CONTAINER_NAME" 2>/dev/null || true
    $DOCKER_CMD rm "$CONTAINER_NAME" 2>/dev/null || true
  fi
  
  # Start the new container
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
else
  # Manual deployment
  print_info "Using manual deployment method..."
  
  # Check if Node.js is installed
  if ! command -v node >/dev/null 2>&1; then
    print_warning "Node.js not found. This deployment method requires Node.js to be installed on the server."
    print_info "Trying to locate Node.js binary in common paths..."
    
    # Look for node in common paths
    for path in /usr/bin /usr/local/bin ~/.nvm/versions/node/*/bin /opt/homebrew/bin; do
      if [ -x "$path/node" ]; then
        export PATH="$path:$PATH"
        print_success "Found Node.js at $path/node"
        break
      fi
    done
    
    # Verify Node.js is now in path
    if ! command -v node >/dev/null 2>&1; then
      print_error "Node.js is required but not found. Please install Node.js or use Docker deployment method."
    fi
  fi
  
  # Install PM2 if not already installed
  if ! command -v pm2 >/dev/null 2>&1; then
    print_info "Installing PM2 for process management..."
    npm install -g pm2 || {
      print_error "Failed to install PM2. Please check npm permissions."
    }
  fi
  
  # Copy extracted files to app directory if they exist
  if [ -d "./extracted" ]; then
    print_info "Setting up application files from extracted archive..."
    
    # Look for the app directory in the extracted files
    app_dir=$(find ./extracted -type d -name "app" -o -name "dist" | head -n 1)
    
    if [ -n "$app_dir" ]; then
      print_info "Found application directory at $app_dir"
      
      # Create deployment directory
      mkdir -p ./deployment
      
      # Copy files
      cp -R "$app_dir"/* ./deployment/
      
      # Copy environment file
      cp .env ./deployment/
      
      print_success "Files copied to deployment directory"
    else
      print_error "Could not find application directory in extracted files"
    fi
  else
    print_warning "No extracted files found, skipping file setup"
  fi
  
  # Start or restart the application with PM2
  print_info "Starting application with PM2..."
  if [ -d "./deployment" ]; then
    cd ./deployment || {
      print_error "Failed to navigate to deployment directory"
    }
    
    # Start with PM2
    if pm2 start npm --name "$CONTAINER_NAME" -- start; then
      print_success "Application started successfully with PM2!"
    else
      print_error "Failed to start application with PM2"
    fi
  else
    print_error "Deployment directory not found"
  fi
fi

# Clean up
print_info "Cleaning up..."
# Clean up tar file if it exists
if [ -n "$TAR_FILE" ] && [ -f "$TAR_FILE" ]; then
  rm -f "$TAR_FILE"
fi

# Clean up extracted directory if it exists
if [ -d "./extracted" ]; then
  rm -rf "./extracted"
fi

print_success "Deployment completed successfully using $DEPLOY_METHOD method!"