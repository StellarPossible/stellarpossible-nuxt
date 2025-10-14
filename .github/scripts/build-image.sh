#!/bin/bash
#
# Docker Image Build Script
# This script builds a Docker image for the Nuxt.js application.
#

set -e # Exit on any error

# Default values
IMAGE_NAME=${IMAGE_NAME:-"stellarpossible-nuxt"}
TAG=${TAG:-"latest"}
GIT_SHA=${GIT_SHA:-$(git rev-parse --short HEAD)}

# Print colorful messages
print_info() {
  echo -e "\033[36m🐳 [BUILD] $1\033[0m"
}

print_success() {
  echo -e "\033[32m✅ [BUILD] $1\033[0m"
}

print_warning() {
  echo -e "\033[33m⚠️ [BUILD] $1\033[0m"
}

print_error() {
  echo -e "\033[31m❌ [BUILD] $1\033[0m"
  exit 1
}

# Check Docker socket permissions
print_info "Checking Docker permissions..."
if [ ! -w /var/run/docker.sock ] && [ -e /var/run/docker.sock ]; then
  print_warning "Docker socket permission issue detected. Attempting to fix..."
  
  # Check if we have sudo access and docker group exists
  if command -v sudo >/dev/null 2>&1 && getent group docker >/dev/null; then
    print_info "Adding current user to the docker group..."
    sudo usermod -aG docker "$(whoami)"
    print_info "Please note: You may need to reconnect to the server for group changes to take effect"
    
    # Try using sudo for this session
    print_info "Using sudo for Docker commands in this session..."
    DOCKER_CMD="sudo docker"
  else
    print_warning "Cannot automatically fix permissions. Using sudo for Docker commands..."
    DOCKER_CMD="sudo docker"
  fi
else
  # Docker socket is accessible
  DOCKER_CMD="docker"
fi

# Export the Docker command for use in the rest of the script
export DOCKER_CMD

# Check if Dockerfile exists
if [ ! -f "Dockerfile" ]; then
  print_error "Dockerfile not found in the current directory!"
fi

# Check if package.json exists
if [ ! -f "package.json" ]; then
  print_error "package.json not found in the current directory!"
fi

print_info "Building Docker image: $IMAGE_NAME:$TAG"
print_info "Git SHA: $GIT_SHA"

# Print the Node.js version to be used
NODE_VERSION=$(grep -o '"node": "[^"]*"' package.json | cut -d'"' -f4 || echo "not specified")
print_info "Required Node.js version: $NODE_VERSION"

# Build the Docker image
print_info "Starting Docker build..."
if $DOCKER_CMD build \
  --build-arg NODE_ENV=production \
  --tag "$IMAGE_NAME:$TAG" \
  --tag "$IMAGE_NAME:$GIT_SHA" \
  .; then
  
  print_success "Docker image built successfully!"
else
  print_error "Docker build failed!"
fi

# Show image info
print_info "Docker image details:"
$DOCKER_CMD images "$IMAGE_NAME"

# Save Docker image if requested
if [ "$SAVE_IMAGE" = "true" ]; then
  print_info "Saving Docker image to tar file..."
  TARFILE="${IMAGE_NAME}-${GIT_SHA}.tar.gz"
  
  if $DOCKER_CMD save "$IMAGE_NAME:$TAG" | gzip > "$TARFILE"; then
    print_success "Docker image saved to $TARFILE"
    ls -lh "$TARFILE"
  else
    print_error "Failed to save Docker image!"
  fi
fi

print_success "Docker build process completed!"