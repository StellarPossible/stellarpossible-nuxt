#!/bin/bash
#
# Container Testing Script
# This script tests the Docker container to ensure it works correctly.
#

set -e # Exit on any error

# Default values
IMAGE_NAME=${IMAGE_NAME:-"stellarpossible-nuxt"}
TAG=${TAG:-"latest"}
TEST_PORT=${TEST_PORT:-"3006"}
WAIT_TIME=${WAIT_TIME:-15}
MAX_RETRIES=${MAX_RETRIES:-3}
TEST_CONTAINER_NAME="test-container-$(date +%s)"
TEST_PORT_START=${TEST_PORT_START:-3006}
TEST_PORT_END=${TEST_PORT_END:-3099}

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

port_in_use() {
  local port="$1"
  if command -v ss >/dev/null 2>&1; then
    ss -tln | awk '{print $4}' | grep -qE ":${port}$"
    return $?
  fi
  if command -v nc >/dev/null 2>&1; then
    nc -z 127.0.0.1 "$port" >/dev/null 2>&1
    return $?
  fi
  (echo >/dev/tcp/127.0.0.1/"$port") >/dev/null 2>&1
}

find_available_test_port() {
  local port
  for port in $(seq "$TEST_PORT_START" "$TEST_PORT_END"); do
    if ! port_in_use "$port"; then
      echo "$port"
      return 0
    fi
  done
  return 1
}

cleanup_stale_test_containers() {
  local ids
  ids=$($DOCKER_CMD ps -aq -f "name=test-container-" 2>/dev/null || true)
  if [ -n "$ids" ]; then
    print_warning "Removing stale test containers from previous runs..."
    # shellcheck disable=SC2086
    $DOCKER_CMD rm -f $ids 2>/dev/null || true
  fi
}

# Clean up function to ensure we always remove the test container
cleanup() {
  print_info "Cleaning up test container..."
  $DOCKER_CMD stop "$TEST_CONTAINER_NAME" 2>/dev/null || true
  $DOCKER_CMD rm "$TEST_CONTAINER_NAME" 2>/dev/null || true
}

# Set up cleanup trap
trap cleanup EXIT INT TERM

print_info "Starting container testing for $IMAGE_NAME:$TAG"

cleanup_stale_test_containers

if port_in_use "$TEST_PORT"; then
  chosen_port=$(find_available_test_port) || print_error "No free port in range ${TEST_PORT_START}-${TEST_PORT_END} for smoke test!"
  print_warning "Port $TEST_PORT is in use — using $chosen_port instead"
  TEST_PORT="$chosen_port"
fi

# Check if image exists
if ! $DOCKER_CMD image inspect "$IMAGE_NAME:$TAG" &>/dev/null; then
  print_error "Image $IMAGE_NAME:$TAG does not exist!"
fi

# Start the container for testing
print_info "Starting test container on port $TEST_PORT..."
if ! $DOCKER_CMD run -d \
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
if ! $DOCKER_CMD ps -q -f "name=$TEST_CONTAINER_NAME" | grep -q .; then
  print_error "Container stopped unexpectedly! Showing logs:"
  $DOCKER_CMD logs "$TEST_CONTAINER_NAME"
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
$DOCKER_CMD logs "$TEST_CONTAINER_NAME"