#!/bin/bash
#
# Health Check Script
# This script performs health checks on the deployed application.
#

set -e # Exit on any error

# Default values
CONTAINER_NAME=${CONTAINER_NAME:-"stellarpossible-app"}
HOST=${HOST:-"localhost"}
PORT=${PORT:-"3000"}
RETRIES=${RETRIES:-5}
DELAY=${DELAY:-10}
CHECK_EXTERNAL=${CHECK_EXTERNAL:-"false"}
EXTERNAL_URL=${EXTERNAL_URL:-"https://stellarpossible.com/"}

# Print colorful messages
print_info() {
  echo -e "\033[36m🩺 [HEALTH] $1\033[0m"
}

print_success() {
  echo -e "\033[32m✅ [HEALTH] $1\033[0m"
}

print_warning() {
  echo -e "\033[33m⚠️ [HEALTH] $1\033[0m"
}

print_error() {
  echo -e "\033[31m❌ [HEALTH] $1\033[0m"
}

# Setup deployment method
DOCKER_CMD=${DOCKER_CMD:-"docker"}
DEPLOY_METHOD=${DEPLOY_METHOD:-"docker"}

print_info "Checking deployment type..."
if [ "$DEPLOY_METHOD" = "manual" ]; then
  print_info "Manual deployment detected, will check process status using PM2"
  
  # Verify PM2 is available
  if command -v pm2 >/dev/null 2>&1; then
    print_success "PM2 is available for process management"
  else
    print_warning "PM2 not found - health checks will be limited"
  fi
else
  print_info "Docker deployment detected, checking Docker status..."
  
  # Check if docker command works
  if $DOCKER_CMD info >/dev/null 2>&1; then
    print_success "Docker is accessible!"
  else
    print_warning "Docker command failed. Will use alternative health checks..."
    DEPLOY_METHOD="manual"
  fi
fi

# Function to check if the application is running
check_container_status() {
  if [ "$DEPLOY_METHOD" = "manual" ]; then
    print_info "Checking application process status..."
    
    if command -v pm2 >/dev/null 2>&1; then
      # Check if process is running with PM2
      if pm2 list | grep -q "$CONTAINER_NAME"; then
        print_success "Application process is running via PM2!"
        pm2 info "$CONTAINER_NAME" || true
        return 0
      else
        print_error "Application process is not running in PM2!"
        pm2 list || true
        return 1
      fi
    else
      # If PM2 not available, check process directly
      print_info "Checking for Node.js process serving on port $PORT..."
      if netstat -tlnp 2>/dev/null | grep -q ":$PORT.*node"; then
        print_success "Node.js process found serving on port $PORT!"
        netstat -tlnp | grep ":$PORT" || true
        return 0
      else
        print_warning "No Node.js process found serving on port $PORT"
        # Don't fail here as we'll check HTTP access directly
        return 0
      fi
    fi
  else
    print_info "Checking container status..."
    
    if $DOCKER_CMD ps -q -f "name=$CONTAINER_NAME" | grep -q .; then
      print_success "Container is running!"
      $DOCKER_CMD ps -f "name=$CONTAINER_NAME"
      return 0
    else
      print_error "Container is not running!"
      $DOCKER_CMD ps -a -f "name=$CONTAINER_NAME" || true
      return 1
    fi
  fi
}

# Function to check if the application responds to HTTP requests
check_local_http() {
  print_info "Checking local HTTP response on $HOST:$PORT..."
  
  for i in $(seq 1 "$RETRIES"); do
    print_info "HTTP check attempt $i of $RETRIES..."
    
    # Check if port is being listened on
    if command -v netstat &>/dev/null; then
      print_info "Checking port status:"
      netstat -tlnp | grep ":$PORT" || print_warning "Port $PORT not found in netstat output"
    fi
    
    # Make HTTP request
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "http://$HOST:$PORT/" -m 10)
    
    if [ "$HTTP_CODE" = "200" ]; then
      print_success "Application is responding with HTTP 200 OK!"
      return 0
    else
      print_warning "Received HTTP code $HTTP_CODE instead of 200"
      print_info "Waiting ${DELAY}s before retry..."
      sleep "$DELAY"
    fi
  done
  
  print_error "Application did not respond with HTTP 200 after $RETRIES attempts"
  return 1
}

# Function to check if the API endpoint is working
check_api_endpoint() {
  print_info "Checking API endpoint..."
  
  HTTP_CODE=$(curl -s -o /tmp/api_response.txt -w "%{http_code}" "http://$HOST:$PORT/api/test-wp" -m 15)
  
  if [ "$HTTP_CODE" = "200" ]; then
    print_success "API endpoint is responding with HTTP 200!"
    print_info "API response: $(cat /tmp/api_response.txt)"
    rm -f /tmp/api_response.txt
    return 0
  else
    print_warning "API endpoint returned HTTP $HTTP_CODE"
    print_info "Response (if any): $(cat /tmp/api_response.txt 2>/dev/null || echo "No response")"
    rm -f /tmp/api_response.txt
    return 1
  fi
}

# Function to check external URL
check_external_url() {
  print_info "Checking external URL: $EXTERNAL_URL"
  
  for i in $(seq 1 3); do
    print_info "External check attempt $i of 3..."
    
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$EXTERNAL_URL" -m 30)
    
    if [ "$HTTP_CODE" = "200" ]; then
      print_success "External URL is accessible with HTTP 200 OK!"
      return 0
    else
      print_warning "External URL returned HTTP $HTTP_CODE"
      print_info "Waiting 15s before retry..."
      sleep 15
    fi
  done
  
  print_warning "External URL did not return HTTP 200 after 3 attempts"
  print_info "This might be due to reverse proxy configuration or DNS propagation"
  return 0  # Don't fail the health check for external access
}

# Function to show container logs
show_container_logs() {
  print_info "Container logs (last 50 lines):"
  $DOCKER_CMD logs "$CONTAINER_NAME" --tail 50 || print_warning "Failed to retrieve container logs"
}

# Function to show container details
show_container_details() {
  print_info "Container details:"
  $DOCKER_CMD inspect "$CONTAINER_NAME" | grep -E "\"Name\"|\"Image\"|\"Status\"|\"Error\"" || 
    print_warning "Failed to retrieve container details"
    
  print_info "Container resource usage:"
  $DOCKER_CMD stats "$CONTAINER_NAME" --no-stream || print_warning "Failed to retrieve resource usage"
}

# Main health check flow
print_info "Starting health checks for container $CONTAINER_NAME"

# Check if container is running
if ! check_container_status; then
  show_container_logs
  exit 1
fi

# Check if application responds locally
if ! check_local_http; then
  show_container_logs
  show_container_details
  exit 1
fi

# Try API endpoint but don't fail if it doesn't work
check_api_endpoint || print_warning "API endpoint check failed but continuing"

# Check external URL if requested
if [ "$CHECK_EXTERNAL" = "true" ]; then
  check_external_url
fi

# If we reached here, the health check passed
print_success "All health checks passed successfully!"
exit 0