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
STRIPE_SECRET_KEY=${STRIPE_SECRET_KEY:-""}
STRIPE_PRICE_MONTHLY=${STRIPE_PRICE_MONTHLY:-""}
STRIPE_PRICE_ANNUAL=${STRIPE_PRICE_ANNUAL:-""}
NUXT_PUBLIC_SITE_URL=${NUXT_PUBLIC_SITE_URL:-"https://stellarpossible.com"}

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
  # For manual deployment, we need to extract the application files from the Docker image
  print_info "Extracting application files from $TAR_FILE for manual deployment..."
  
  # Check if we have our utility script available
  if [ -f "/tmp/extract-docker-image.sh" ]; then
    print_info "Using extract-docker-image.sh utility script"
    chmod +x /tmp/extract-docker-image.sh
    
    # Run the extraction utility
    if /tmp/extract-docker-image.sh "$TAR_FILE" "./extracted" "./tmp_extract"; then
      print_success "Application files extracted successfully!"
    else
      print_error "Failed to extract application files using utility script!"
    fi
  else
    print_info "Extract utility not found, using built-in extraction method"
    
    # Create a temporary directory for extraction
    mkdir -p ./extracted ./tmp_extract
    
    # First, try to extract the tar.gz directly (it might be a simple archive)
    if tar -xzf "$TAR_FILE" -C ./tmp_extract 2>/dev/null; then
      print_success "Successfully extracted as a simple archive!"
      
      # Move the contents to our extracted directory
      cp -r ./tmp_extract/* ./extracted/ 2>/dev/null || true
    else
      print_info "Appears to be a Docker image, trying Docker-specific extraction..."
      
      # Decompress the Docker image
      gunzip -c "$TAR_FILE" > ./tmp_extract/docker_image.tar || {
        print_error "Failed to decompress Docker image"
        DEPLOY_METHOD="failed"
        return 1
      }
      
      # Create a directory for layers
      mkdir -p ./tmp_extract/layers
      
      # Extract the Docker image
      if ! tar -xf ./tmp_extract/docker_image.tar -C ./tmp_extract/layers 2>/dev/null; then
        print_error "Failed to extract Docker image"
        DEPLOY_METHOD="failed"
        return 1
      fi
      
      # Find and extract layers
      for layer in $(find ./tmp_extract/layers -name "*.tar" 2>/dev/null); do
        print_info "Extracting layer: $(basename "$layer")"
        mkdir -p ./tmp_extract/current_layer
        
        # Extract this layer
        tar -xf "$layer" -C ./tmp_extract/current_layer 2>/dev/null || continue
        
        # Copy layer contents to extracted directory
        cp -r ./tmp_extract/current_layer/* ./extracted/ 2>/dev/null || true
        
        # Clean up current layer
        rm -rf ./tmp_extract/current_layer
      done
      
      # Look for the app directory structure
      if [ -d "./extracted/app" ]; then
        print_success "Found app directory at ./extracted/app"
      elif [ -d "./extracted/usr/src/app" ]; then
        print_success "Found app directory at ./extracted/usr/src/app"
        mkdir -p ./tmp_extract/app_content
        cp -r ./extracted/usr/src/app/* ./tmp_extract/app_content/ 2>/dev/null || true
        rm -rf ./extracted
        mkdir -p ./extracted
        cp -r ./tmp_extract/app_content/* ./extracted/ 2>/dev/null || true
        rm -rf ./tmp_extract/app_content
      fi
    fi
  fi
  
  # Check if we have any useful files
  if [ ! -d "./extracted" ] || [ -z "$(ls -A ./extracted 2>/dev/null)" ]; then
    print_error "No application files were successfully extracted!"
  else
    print_info "Extracted files:"
    ls -la ./extracted/
  fi
fi

# Verify Stripe secret is present (do not print value)
if [ -z "$STRIPE_SECRET_KEY" ]; then
  print_warning "STRIPE_SECRET_KEY is empty - add it as a GitHub Actions secret and re-deploy."
else
  print_success "STRIPE_SECRET_KEY is set."
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

# Stripe (subscriptions) - quoted so special characters are preserved
STRIPE_SECRET_KEY="$STRIPE_SECRET_KEY"
STRIPE_PRICE_MONTHLY="$STRIPE_PRICE_MONTHLY"
STRIPE_PRICE_ANNUAL="$STRIPE_PRICE_ANNUAL"
NUXT_PUBLIC_SITE_URL="$NUXT_PUBLIC_SITE_URL"

# Nuxt 3 overrides runtimeConfig at runtime only for NUXT_* env vars
NUXT_STRIPE_SECRET_KEY="$STRIPE_SECRET_KEY"
NUXT_STRIPE_PRICE_MONTHLY="$STRIPE_PRICE_MONTHLY"
NUXT_STRIPE_PRICE_ANNUAL="$STRIPE_PRICE_ANNUAL"
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
  
  # Print Node.js version for diagnostics
  print_info "Using Node.js version: $(node -v)"
  
  # Install PM2 if not already installed
  if ! command -v pm2 >/dev/null 2>&1; then
    print_info "Installing PM2 for process management..."
    npm install -g pm2 || {
      print_error "Failed to install PM2. Please check npm permissions."
    }
  else
    print_info "Using existing PM2 installation: $(pm2 -v)"
  fi
  
  # Set up deployment directory
  mkdir -p ./deployment
  
  # Copy extracted files to deployment directory if they exist
  if [ -d "./extracted" ]; then
    print_info "Setting up application files from extracted archive..."
    
    # For Nuxt.js applications, prioritize .output directory
    if [ -d "./extracted/.output" ]; then
      print_success "Found Nuxt output directory at ./extracted/.output"
      cp -R ./extracted/.output ./deployment/
      cp -R ./extracted/package.json ./deployment/ 2>/dev/null || true
    elif [ -d "./extracted/app/.output" ]; then
      print_success "Found Nuxt output directory at ./extracted/app/.output"
      cp -R ./extracted/app/.output ./deployment/
      cp -R ./extracted/app/package.json ./deployment/ 2>/dev/null || true
    elif [ -f "./extracted/package.json" ]; then
      print_success "Found package.json at root level"
      cp -R ./extracted/* ./deployment/
    else
      # Just copy everything and hope for the best
      print_warning "Could not identify specific app structure, copying all files"
      cp -R ./extracted/* ./deployment/ 2>/dev/null || true
    fi
    
    # Copy environment file to deployment directory
    cp .env ./deployment/ || print_warning "Could not copy environment file"
    
    # Check if we have the necessary files for a Node.js application
    if [ ! -f "./deployment/package.json" ]; then
      print_warning "No package.json found in deployment directory. Creating a basic one..."
      cat > ./deployment/package.json << EOF
{
  "name": "stellarpossible-nuxt",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "scripts": {
    "start": "node .output/server/index.mjs"
  }
}
EOF
    fi
    
    # Check if we have a server entry point
    if [ ! -f "./deployment/server/index.js" ] && [ ! -f "./deployment/index.js" ]; then
      print_warning "No server entry point found. Looking for alternatives..."
      
      # Try to find any JS file that could be an entry point
      entry_point=$(find ./deployment -type f -name "*.js" | grep -E 'server|index|main|app' | head -n 1)
      
      if [ -n "$entry_point" ]; then
        print_success "Found potential entry point: $entry_point"
        
        # Update package.json start script
        if [ -f "./deployment/package.json" ]; then
          relative_path="${entry_point#./deployment/}"
          sed -i.bak "s|\"start\":.*|\"start\": \"node $relative_path\"|" ./deployment/package.json
          rm -f ./deployment/package.json.bak
        fi
      else
        print_warning "Could not find any suitable entry point"
      fi
    fi
  else
    print_error "No extracted files found for deployment"
  fi
  
  # Start or restart the application with PM2
  print_info "Starting application with PM2..."
  if [ -d "./deployment" ]; then
    cd ./deployment || {
      print_error "Failed to navigate to deployment directory"
    }
    
    # Check if we need to install dependencies
    if [ -f "package.json" ]; then
      if [ ! -d "node_modules" ]; then
        print_info "Installing dependencies..."
        npm install --production || print_warning "Dependency installation failed, continuing anyway"
      fi
    fi
    
    # Determine the start command based on what's available
    START_CMD="npm start"
    if [ -f ".output/server/index.mjs" ]; then
      START_CMD="node .output/server/index.mjs"
    elif [ -f "server/index.js" ]; then
      START_CMD="node server/index.js"
    elif [ -f "index.js" ]; then
      START_CMD="node index.js"
    fi
    
    print_info "Using start command: $START_CMD"
    
    # Check if the process is already running in PM2
    if pm2 list | grep -q "$CONTAINER_NAME"; then
      print_info "Application already running in PM2, reloading..."
      pm2 reload "$CONTAINER_NAME" || {
        print_warning "Failed to reload, attempting to restart..."
        pm2 restart "$CONTAINER_NAME" || {
          print_warning "Failed to restart, stopping and starting fresh..."
          pm2 delete "$CONTAINER_NAME" 2>/dev/null || true
          pm2 start --name "$CONTAINER_NAME" $START_CMD
        }
      }
    else
      # Start fresh with PM2
      print_info "Starting fresh application instance with PM2..."
      pm2 start --name "$CONTAINER_NAME" $START_CMD
    fi
    
    # Verify the process is running
    if pm2 list | grep -q "$CONTAINER_NAME"; then
      print_success "Application started successfully with PM2!"
      pm2 show "$CONTAINER_NAME"
    else
      print_error "Failed to start application with PM2"
    fi
  else
    print_error "Deployment directory not found"
  fi
fi

# Clean up
print_info "Cleaning up temporary files..."

# Clean up tar file if it exists and deployment was successful
if [ -n "$TAR_FILE" ] && [ -f "$TAR_FILE" ]; then
  rm -f "$TAR_FILE"
fi

# Clean up all temporary directories we might have created
for dir in "./extracted" "./tmp_extract" "./docker_layers" "./container_extract"; do
  if [ -d "$dir" ]; then
    print_info "Removing $dir directory..."
    rm -rf "$dir"
  fi
done

print_success "Deployment completed successfully using $DEPLOY_METHOD method!"

# If this was a manual deployment, print some helpful information
if [ "$DEPLOY_METHOD" = "manual" ]; then
  print_info "Manual deployment information:"
  print_info "Application should be running using PM2. To check status: pm2 list"
  print_info "To view logs: pm2 logs $CONTAINER_NAME"
  print_info "To restart app: pm2 restart $CONTAINER_NAME"
  print_info "To stop app: pm2 stop $CONTAINER_NAME"
fi