#!/bin/bash
#
# Container Testing Script
# This script tests the Docker container to ensure it works correctly.
#

set -e # Exit on any error

# Default values
IMAGE_NAME=${IMAGE_NAME:-"stellarpossible-nuxt"}
TAG=${TAG:-"latest"}
TEST_PORT=${TEST_PORT:-"3001"}
WAIT_TIME=${WAIT_TIME:-15}
MAX_RETRIES=${MAX_RETRIES:-3}
TEST_CONTAINER_NAME="test-container-$(date +%s)"

# Environment variables needed for testing
WP_USER=${WP_USER:-"admin"}
WP_APP_PASSWORD=${WP_APP_PASSWORD:-"test-password"}
WP_GRAPHQL_ENDPOINT=${WP_GRAPHQL_ENDPOINT:-"https://stellarpossible.com/cms/graphql"}
WP_REST_ENDPOINT=${WP_REST_ENDPOINT:-"https://stellarpossible.com/cms/wp-json"}
WP_API_URL=${WP_API_URL:-"https://stellarpossible.com/cms"}
USE_JWT=${USE_JWT:-"false"}
JWT_SECRET=${JWT_SECRET:-"test-secret"}

# Print colorful messages
print_info() {
  echo -e "\033[36m🧪 [TEST] $1\033[0m"
}

print_success() {
  echo -e "\033[32m✅ [TEST] $1\033[0m"
}

print_warning() {
  echo -e "\033[33m⚠️ [TEST] $1\033[0m"
}

print_error() {
  echo -e "\033[31m❌ [TEST] $1\033[0m"
  exit 1
}

# Clean up function to ensure we always remove the test container
cleanup() {
  print_info "Cleaning up test container..."
  docker stop "$TEST_CONTAINER_NAME" 2>/dev/null || true
  docker rm "$TEST_CONTAINER_NAME" 2>/dev/null || true
}

# Set up cleanup trap
trap cleanup EXIT INT TERM

print_info "Starting container testing for $IMAGE_NAME:$TAG"

# Check if image exists
if ! docker image inspect "$IMAGE_NAME:$TAG" &>/dev/null; then
  print_error "Image $IMAGE_NAME:$TAG does not exist!"
fi

# Start the container for testing
print_info "Starting test container on port $TEST_PORT..."
if ! docker run -d \
  --name "$TEST_CONTAINER_NAME" \
  -p "$TEST_PORT:3000" \
  -e NODE_ENV=production \
  -e WP_USER="$WP_USER" \
  -e WP_APP_PASSWORD="$WP_APP_PASSWORD" \
  -e WP_GRAPHQL_ENDPOINT="$WP_GRAPHQL_ENDPOINT" \
  -e WP_REST_ENDPOINT="$WP_REST_ENDPOINT" \
  -e WP_API_URL="$WP_API_URL" \
  -e USE_JWT="$USE_JWT" \
  -e JWT_SECRET="$JWT_SECRET" \
  "$IMAGE_NAME:$TAG"; then
  
  print_error "Failed to start test container!"
fi

# Wait for container to start
print_info "Waiting for container to start (${WAIT_TIME}s)..."
sleep "$WAIT_TIME"

# Check if container is still running
if ! docker ps -q -f "name=$TEST_CONTAINER_NAME" | grep -q .; then
  print_error "Container stopped unexpectedly! Showing logs:"
  docker logs "$TEST_CONTAINER_NAME"
fi

# Test the container with retries
print_info "Testing container HTTP response..."
for i in $(seq 1 "$MAX_RETRIES"); do
  print_info "Test attempt $i of $MAX_RETRIES..."
  
  if curl -fs "http://localhost:$TEST_PORT/" > /dev/null; then
    print_success "Container is responding correctly!"
    
    # Optional: Test API endpoint if needed
    if curl -fs "http://localhost:$TEST_PORT/api/test-wp" > /dev/null; then
      print_success "API endpoint is also working!"
    else
      print_warning "API endpoint is not responding, but main site is working."
    fi
    
    # Test passed, exit normally
    print_success "Container tests passed successfully!"
    exit 0
  else
    print_warning "Container not responding yet, retrying in 5s..."
    sleep 5
  fi
done

# If we reach here, all retries failed
print_error "Container is not responding after $MAX_RETRIES attempts! Showing logs:"
docker logs "$TEST_CONTAINER_NAME"