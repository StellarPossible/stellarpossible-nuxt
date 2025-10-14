#!/bin/bash
#
# Docker Image Inspector
# Utility to inspect and debug Docker image contents
#

# Default values
IMAGE_TAR=${1:-""}
OUTPUT_DIR=${2:-"./docker_inspect"}

# Print help if no arguments provided
if [ -z "$IMAGE_TAR" ]; then
  echo "Docker Image Inspector - Utility to inspect Docker image contents"
  echo "Usage: $0 <image-tar.gz> [output-dir]"
  echo ""
  echo "This script extracts and analyzes a Docker image tar.gz file to help"
  echo "understand its structure. Useful for debugging Docker image issues."
  echo ""
  echo "Arguments:"
  echo "  image-tar.gz  - Path to the Docker image tar.gz file"
  echo "  output-dir    - Directory to store inspection results (default: ./docker_inspect)"
  exit 1
fi

# Check if file exists
if [ ! -f "$IMAGE_TAR" ]; then
  echo "Error: File not found: $IMAGE_TAR"
  exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Function for colorful output
print_info() {
  echo -e "\033[36m[INFO] $1\033[0m"
}

print_success() {
  echo -e "\033[32m[SUCCESS] $1\033[0m"
}

print_warning() {
  echo -e "\033[33m[WARNING] $1\033[0m"
}

print_error() {
  echo -e "\033[31m[ERROR] $1\033[0m"
}

# Start the inspection
print_info "Starting inspection of Docker image: $IMAGE_TAR"

# Extract file type information
print_info "Checking file type..."
file_info=$(file "$IMAGE_TAR")
echo "$file_info" > "$OUTPUT_DIR/file_info.txt"
echo "File type: $file_info"

# Decompress the image
print_info "Decompressing image..."
gunzip -c "$IMAGE_TAR" > "$OUTPUT_DIR/docker_image.tar" || {
  print_error "Failed to decompress image"
  exit 1
}

# Extract the tar contents
print_info "Extracting image layers..."
mkdir -p "$OUTPUT_DIR/layers"
tar -xf "$OUTPUT_DIR/docker_image.tar" -C "$OUTPUT_DIR/layers" || {
  print_error "Failed to extract image"
  exit 1
}

# Check for manifest
print_info "Checking for manifest.json..."
if [ -f "$OUTPUT_DIR/layers/manifest.json" ]; then
  print_success "Found manifest.json"
  cp "$OUTPUT_DIR/layers/manifest.json" "$OUTPUT_DIR/manifest.json"
  
  # Extract useful information from manifest
  print_info "Extracting image information from manifest..."
  cat "$OUTPUT_DIR/manifest.json" | grep -o '"Config":"[^"]*"' > "$OUTPUT_DIR/config_file.txt"
  
  # Get layer information
  print_info "Layer information:"
  cat "$OUTPUT_DIR/manifest.json" | grep -o '"Layers":\[[^]]*\]' > "$OUTPUT_DIR/layers.txt"
  
  # Count layers
  layers=$(cat "$OUTPUT_DIR/manifest.json" | grep -o '"Layers":\[[^]]*\]' | grep -o '.tar.gz' | wc -l)
  echo "Number of layers: $layers" >> "$OUTPUT_DIR/image_info.txt"
  echo "Number of layers: $layers"
else
  print_warning "No manifest.json found"
fi

# Count number of layer files
layer_count=$(find "$OUTPUT_DIR/layers" -name "*.tar" | wc -l)
echo "Number of tar files found: $layer_count" >> "$OUTPUT_DIR/image_info.txt"
echo "Number of tar files found: $layer_count"

# Check for config file
config_files=$(find "$OUTPUT_DIR/layers" -name "*.json" | grep -v manifest)
if [ -n "$config_files" ]; then
  print_info "Found config files:"
  echo "$config_files" | tee "$OUTPUT_DIR/config_files.txt"
  
  # Copy the first config file for inspection
  first_config=$(echo "$config_files" | head -n 1)
  cp "$first_config" "$OUTPUT_DIR/config.json"
fi

# Extract the first layer to inspect structure
print_info "Extracting a sample layer to inspect structure..."
sample_layer=$(find "$OUTPUT_DIR/layers" -name "*.tar" | head -n 1)
if [ -n "$sample_layer" ]; then
  mkdir -p "$OUTPUT_DIR/sample_layer"
  tar -xf "$sample_layer" -C "$OUTPUT_DIR/sample_layer" || print_warning "Failed to extract sample layer"
  
  # List the top-level directories in the sample layer
  print_info "Top-level directories in sample layer:"
  find "$OUTPUT_DIR/sample_layer" -maxdepth 1 -type d | grep -v "^$OUTPUT_DIR/sample_layer$" | tee "$OUTPUT_DIR/layer_dirs.txt"
fi

# Look for app directories and key files across all layers
print_info "Looking for key application directories and files..."
mkdir -p "$OUTPUT_DIR/extracted_layers"

# Process each layer
layer_number=0
for layer in $(find "$OUTPUT_DIR/layers" -name "*.tar"); do
  layer_number=$((layer_number + 1))
  layer_dir="$OUTPUT_DIR/extracted_layers/layer_$layer_number"
  mkdir -p "$layer_dir"
  
  print_info "Extracting layer $layer_number: $(basename "$layer")..."
  tar -xf "$layer" -C "$layer_dir" || {
    print_warning "Failed to extract layer $layer_number, skipping"
    continue
  }
  
  # Look for app directories
  app_dirs=$(find "$layer_dir" -type d -path "*/app" -o -path "*/usr/src/app" -o -path "*/.output" 2>/dev/null)
  if [ -n "$app_dirs" ]; then
    echo "Layer $layer_number app directories:" >> "$OUTPUT_DIR/app_locations.txt"
    echo "$app_dirs" >> "$OUTPUT_DIR/app_locations.txt"
    echo "Found app directories in layer $layer_number"
  fi
  
  # Look for package.json files
  pkg_files=$(find "$layer_dir" -name "package.json" 2>/dev/null)
  if [ -n "$pkg_files" ]; then
    echo "Layer $layer_number package.json files:" >> "$OUTPUT_DIR/package_json_locations.txt"
    echo "$pkg_files" >> "$OUTPUT_DIR/package_json_locations.txt"
    echo "Found package.json files in layer $layer_number"
    
    # Copy the first package.json for inspection
    first_pkg=$(echo "$pkg_files" | head -n 1)
    cp "$first_pkg" "$OUTPUT_DIR/package.json.layer_$layer_number"
  fi
  
  # Look for entry point files
  entry_files=$(find "$layer_dir" -name "index.js" -o -name "server.js" -o -name "app.js" 2>/dev/null)
  if [ -n "$entry_files" ]; then
    echo "Layer $layer_number entry point files:" >> "$OUTPUT_DIR/entrypoint_locations.txt"
    echo "$entry_files" >> "$OUTPUT_DIR/entrypoint_locations.txt"
    echo "Found entry point files in layer $layer_number"
  fi
done

# Create a summary file
print_info "Creating inspection summary..."
cat > "$OUTPUT_DIR/summary.txt" << EOF
Docker Image Inspection Summary
==============================
Image: $IMAGE_TAR
Date: $(date)

File Type: $(cat "$OUTPUT_DIR/file_info.txt")
Number of Layers: $layer_number

Key Findings:
EOF

# Add app directories to summary
if [ -f "$OUTPUT_DIR/app_locations.txt" ]; then
  echo "- Application directories found:" >> "$OUTPUT_DIR/summary.txt"
  cat "$OUTPUT_DIR/app_locations.txt" | sed 's/^/  /' >> "$OUTPUT_DIR/summary.txt"
else
  echo "- No application directories found" >> "$OUTPUT_DIR/summary.txt"
fi

# Add package.json files to summary
if [ -f "$OUTPUT_DIR/package_json_locations.txt" ]; then
  echo "- Package.json files found:" >> "$OUTPUT_DIR/summary.txt"
  cat "$OUTPUT_DIR/package_json_locations.txt" | sed 's/^/  /' >> "$OUTPUT_DIR/summary.txt"
else
  echo "- No package.json files found" >> "$OUTPUT_DIR/summary.txt"
fi

# Add entry point files to summary
if [ -f "$OUTPUT_DIR/entrypoint_locations.txt" ]; then
  echo "- Entry point files found:" >> "$OUTPUT_DIR/summary.txt"
  cat "$OUTPUT_DIR/entrypoint_locations.txt" | sed 's/^/  /' >> "$OUTPUT_DIR/summary.txt"
else
  echo "- No entry point files found" >> "$OUTPUT_DIR/summary.txt"
fi

print_success "Inspection complete! Results saved to $OUTPUT_DIR"
print_info "Summary file: $OUTPUT_DIR/summary.txt"