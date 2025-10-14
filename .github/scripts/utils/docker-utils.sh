#!/bin/bash
#
# Docker Utility Functions
# This script provides helper functions for Docker operations.
#

# Print colorful messages
print_info() {
  echo -e "\033[36m🐳 [DOCKER] $1\033[0m"
}

print_success() {
  echo -e "\033[32m✅ [DOCKER] $1\033[0m"
}

print_warning() {
  echo -e "\033[33m⚠️ [DOCKER] $1\033[0m"
}

print_error() {
  echo -e "\033[31m❌ [DOCKER] $1\033[0m"
  return 1
}

# Function to check if Docker is installed and running
check_docker() {
  if ! command -v docker &>/dev/null; then
    print_error "Docker is not installed or not available in PATH!"
    return 1
  fi
  
  if ! docker info &>/dev/null; then
    print_error "Docker daemon is not running or current user doesn't have permissions!"
    return 1
  fi
  
  print_success "Docker is installed and running!"
  return 0
}

# Function to check if an image exists
check_image_exists() {
  local image="$1"
  local tag="${2:-latest}"
  
  if docker image inspect "$image:$tag" &>/dev/null; then
    print_success "Image $image:$tag exists"
    return 0
  else
    print_warning "Image $image:$tag does not exist"
    return 1
  fi
}

# Function to check if a container exists
check_container_exists() {
  local container="$1"
  
  if docker ps -a -q -f "name=$container" | grep -q .; then
    print_success "Container $container exists"
    return 0
  else
    print_warning "Container $container does not exist"
    return 1
  fi
}

# Function to check if a container is running
check_container_running() {
  local container="$1"
  
  if docker ps -q -f "name=$container" | grep -q .; then
    print_success "Container $container is running"
    return 0
  else
    print_warning "Container $container is not running"
    return 1
  fi
}

# Function to safely stop and remove a container
safe_remove_container() {
  local container="$1"
  local force="${2:-false}"
  
  if check_container_exists "$container"; then
    print_info "Stopping container $container..."
    docker stop "$container" &>/dev/null || print_warning "Container was not running"
    
    print_info "Removing container $container..."
    if ! docker rm "$container" &>/dev/null; then
      if [ "$force" = "true" ]; then
        print_warning "Standard removal failed, trying force removal..."
        docker rm -f "$container" &>/dev/null || {
          print_error "Failed to remove container $container even with force!"
          return 1
        }
      else
        print_error "Failed to remove container $container!"
        return 1
      fi
    fi
    
    print_success "Container $container removed successfully"
  else
    print_info "Container $container does not exist, nothing to remove"
  fi
  
  return 0
}

# Function to create a backup of a container
backup_container() {
  local container="$1"
  local image="$2"
  local tag="${3:-backup-$(date +%Y%m%d-%H%M%S)}"
  
  if ! check_container_running "$container"; then
    print_error "Container $container is not running, cannot create backup!"
    return 1
  fi
  
  print_info "Creating backup of container $container as $image:$tag..."
  if docker commit "$container" "$image:$tag"; then
    print_success "Backup created successfully: $image:$tag"
    return 0
  else
    print_error "Failed to create backup of container $container!"
    return 1
  fi
}

# Function to save an image to a tar file
save_image() {
  local image="$1"
  local tag="${2:-latest}"
  local output="${3:-$image-$tag.tar.gz}"
  
  print_info "Saving image $image:$tag to $output..."
  if docker save "$image:$tag" | gzip > "$output"; then
    print_success "Image saved successfully to $output"
    ls -lh "$output"
    return 0
  else
    print_error "Failed to save image $image:$tag to $output!"
    return 1
  fi
}

# Function to load an image from a tar file
load_image() {
  local input="$1"
  
  if [ ! -f "$input" ]; then
    print_error "Input file $input does not exist!"
    return 1
  fi
  
  print_info "Loading image from $input..."
  if gunzip -c "$input" | docker load; then
    print_success "Image loaded successfully!"
    return 0
  else
    print_error "Failed to load image from $input!"
    return 1
  fi
}

# Function to clean up old images
cleanup_old_images() {
  local image="$1"
  local tag_pattern="${2:-backup}"
  local keep="${3:-3}"
  
  print_info "Cleaning up old $image images with tag pattern $tag_pattern..."
  
  # Get count of matching images
  local count=$(docker images "$image" --format "{{.Tag}}" | grep -c "$tag_pattern" 2>/dev/null || echo "0")
  
  if [ "$count" -gt "$keep" ]; then
    print_info "Found $count images, keeping newest $keep..."
    
    # Get list of images to remove
    local images_to_remove=$(docker images "$image" --format "{{.Repository}}:{{.Tag}}" | 
                           grep "$tag_pattern" | sort -r | tail -n +$((keep+1)))
    
    if [ -n "$images_to_remove" ]; then
      echo "$images_to_remove" | xargs -r docker rmi 2>/dev/null || 
        print_warning "Some images could not be removed, they might be in use"
    fi
    
    print_success "Cleanup completed!"
  else
    print_info "Only $count images found with pattern $tag_pattern, no cleanup needed"
  fi
  
  return 0
}