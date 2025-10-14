#!/bin/bash
#
# Docker Image Extraction Utility
# This script extracts application files from a Docker image tar.gz
#

set -e # Exit on any error

# Print colorful messages
print_info() {
  echo -e "\033[36m🔧 [EXTRACT] $1\033[0m"
}

print_success() {
  echo -e "\033[32m✅ [EXTRACT] $1\033[0m"
}

print_warning() {
  echo -e "\033[33m⚠️ [EXTRACT] $1\033[0m"
}

print_error() {
  echo -e "\033[31m❌ [EXTRACT] $1\033[0m"
}

# Default values
IMAGE_TAR=${1:-""}
OUTPUT_DIR=${2:-"./extracted"}
TMP_DIR=${3:-"./tmp_extract"}

# Show usage if no arguments
if [ -z "$IMAGE_TAR" ]; then
  echo "Usage: $0 <docker-image-tar.gz> [output-dir] [temp-dir]"
  echo "  docker-image-tar.gz: Path to Docker image tar.gz file"
  echo "  output-dir: Directory to extract application files to (default: ./extracted)"
  echo "  temp-dir: Temporary directory for extraction (default: ./tmp_extract)"
  exit 1
fi

# Check if image tar exists
if [ ! -f "$IMAGE_TAR" ]; then
  print_error "Docker image tar not found: $IMAGE_TAR"
  exit 1
fi

# Create directories
mkdir -p "$OUTPUT_DIR" "$TMP_DIR"

print_info "Extracting Docker image: $IMAGE_TAR"
print_info "Output directory: $OUTPUT_DIR"

# Try to extract as a simple tar.gz first
if tar -xzf "$IMAGE_TAR" -C "$OUTPUT_DIR" 2>/dev/null; then
  print_success "Successfully extracted as a simple tar.gz archive"
  exit 0
fi

print_info "Not a simple tar.gz, attempting Docker image extraction..."

# Decompress the image
gunzip -c "$IMAGE_TAR" > "$TMP_DIR/docker_image.tar" || {
  print_error "Failed to decompress Docker image"
  exit 1
}

# Create a directory for layers
mkdir -p "$TMP_DIR/layers"

# Extract the Docker image tar
if ! tar -xf "$TMP_DIR/docker_image.tar" -C "$TMP_DIR/layers"; then
  print_error "Failed to extract Docker image tar"
  exit 1
fi

print_success "Docker image extracted successfully"

# Check for manifest
if [ ! -f "$TMP_DIR/layers/manifest.json" ]; then
  print_warning "No manifest.json found, trying to extract layers directly"
  
  # Try to find and extract layer tars directly
  layer_files=$(find "$TMP_DIR/layers" -name "*.tar" 2>/dev/null)
  
  if [ -z "$layer_files" ]; then
    print_error "No layer files found"
    exit 1
  fi
else
  print_info "Found manifest.json, processing layers..."
  
  # Get the layers from the manifest
  layer_files=$(find "$TMP_DIR/layers" -name "*.tar" 2>/dev/null)
fi

# Extract each layer
for layer in $layer_files; do
  print_info "Processing layer: $(basename "$layer")"
  
  # Extract the layer
  mkdir -p "$TMP_DIR/current_layer"
  if ! tar -xf "$layer" -C "$TMP_DIR/current_layer" 2>/dev/null; then
    print_warning "Failed to extract layer: $(basename "$layer"), skipping"
    rm -rf "$TMP_DIR/current_layer"
    continue
  fi
  
  # Copy files to output directory, maintaining directory structure
  print_info "Copying files from layer to output directory..."
  cp -a "$TMP_DIR/current_layer/." "$OUTPUT_DIR/" 2>/dev/null || true
  
  # Clean up current layer
  rm -rf "$TMP_DIR/current_layer"
done

# Identify potential application directories
print_info "Looking for application directories..."

# Check for common Node.js/Nuxt.js directories
found_app_dir=false

# Priority list of directories to look for
for dir_path in \
  "$OUTPUT_DIR/app" \
  "$OUTPUT_DIR/usr/src/app" \
  "$OUTPUT_DIR/usr/app" \
  "$OUTPUT_DIR/opt/app" \
  "$OUTPUT_DIR/.output" \
  "$OUTPUT_DIR/dist" \
  "$OUTPUT_DIR/server"; do
  
  if [ -d "$dir_path" ]; then
    print_success "Found potential application directory: $dir_path"
    found_app_dir=true
    
    # If we found a nested app directory, move its contents to the output root
    if [ "$dir_path" != "$OUTPUT_DIR" ]; then
      print_info "Moving files from $dir_path to $OUTPUT_DIR"
      mkdir -p "$TMP_DIR/app_files"
      cp -a "$dir_path/." "$TMP_DIR/app_files/" 2>/dev/null || true
      rm -rf "$OUTPUT_DIR"
      mkdir -p "$OUTPUT_DIR"
      cp -a "$TMP_DIR/app_files/." "$OUTPUT_DIR/" 2>/dev/null || true
      rm -rf "$TMP_DIR/app_files"
    fi
    
    break
  fi
done

# Look for key files
if ! $found_app_dir; then
  print_warning "No standard app directory found, looking for key files..."
  
  # Look for package.json
  package_files=$(find "$OUTPUT_DIR" -name "package.json" 2>/dev/null | head -n 1)
  
  if [ -n "$package_files" ]; then
    package_dir=$(dirname "$package_files")
    print_success "Found package.json in: $package_dir"
    
    if [ "$package_dir" != "$OUTPUT_DIR" ]; then
      print_info "Moving files from $package_dir to $OUTPUT_DIR"
      mkdir -p "$TMP_DIR/app_files"
      cp -a "$package_dir/." "$TMP_DIR/app_files/" 2>/dev/null || true
      rm -rf "$OUTPUT_DIR"
      mkdir -p "$OUTPUT_DIR"
      cp -a "$TMP_DIR/app_files/." "$OUTPUT_DIR/" 2>/dev/null || true
      rm -rf "$TMP_DIR/app_files"
    fi
    
    found_app_dir=true
  fi
fi

# Look for entry point files if we still haven't found anything
if ! $found_app_dir; then
  print_warning "No package.json found, looking for entry point files..."
  
  # Look for common entry point files
  for entry_file in $(find "$OUTPUT_DIR" -name "index.js" -o -name "server.js" -o -name "app.js" -o -name "main.js" 2>/dev/null); do
    entry_dir=$(dirname "$entry_file")
    print_success "Found entry file: $entry_file"
    
    if [ "$entry_dir" != "$OUTPUT_DIR" ]; then
      print_info "Moving files from $entry_dir to $OUTPUT_DIR"
      mkdir -p "$TMP_DIR/app_files"
      cp -a "$entry_dir/." "$TMP_DIR/app_files/" 2>/dev/null || true
      rm -rf "$OUTPUT_DIR"
      mkdir -p "$OUTPUT_DIR"
      cp -a "$TMP_DIR/app_files/." "$OUTPUT_DIR/" 2>/dev/null || true
      rm -rf "$TMP_DIR/app_files"
    fi
    
    found_app_dir=true
    break
  done
fi

# Check if we have anything useful
if [ -z "$(ls -A "$OUTPUT_DIR" 2>/dev/null)" ]; then
  print_warning "Output directory is empty, extraction might have failed"
else
  print_info "Files in output directory:"
  ls -la "$OUTPUT_DIR"
  
  # Check for key files
  if [ -f "$OUTPUT_DIR/package.json" ]; then
    print_success "Found package.json"
  fi
  
  if [ -f "$OUTPUT_DIR/server/index.js" ] || [ -f "$OUTPUT_DIR/index.js" ] || [ -f "$OUTPUT_DIR/.output/server/index.mjs" ]; then
    print_success "Found server entry point"
  fi
  
  print_success "Extraction complete!"
fi

# Optional: Clean up temporary files
if [ "$4" != "--keep-temp" ]; then
  print_info "Cleaning up temporary files..."
  rm -rf "$TMP_DIR"
fi