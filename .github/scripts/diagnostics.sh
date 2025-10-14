#!/bin/bash
#
# Diagnostics Script
# This script performs diagnostics and checks on the deployed application.
#

set -e # Exit on any error

# Default values
CONTAINER_NAME=${CONTAINER_NAME:-"stellarpossible-app"}
PORT=${PORT:-"3000"}

# Print colorful messages
print_info() {
  echo -e "\033[36m🔍 [DIAGNOSTICS] $1\033[0m"
}

print_success() {
  echo -e "\033[32m✅ [DIAGNOSTICS] $1\033[0m"
}

print_warning() {
  echo -e "\033[33m⚠️ [DIAGNOSTICS] $1\033[0m"
}

print_error() {
  echo -e "\033[31m❌ [DIAGNOSTICS] $1\033[0m"
}

# Setup deployment method
DOCKER_CMD=${DOCKER_CMD:-"docker"}
DEPLOY_METHOD=${DEPLOY_METHOD:-"docker"}

print_info "Checking deployment type..."
if [ "$DEPLOY_METHOD" = "manual" ]; then
  print_info "Manual deployment detected, will use PM2 and process diagnostics"
  
  # Verify PM2 is available
  if command -v pm2 >/dev/null 2>&1; then
    print_success "PM2 is available for process management"
  else
    print_warning "PM2 not found - diagnostics will be limited"
  fi
else
  print_info "Docker deployment detected, checking Docker status..."
  
  # Check if docker command works
  if $DOCKER_CMD info >/dev/null 2>&1; then
    print_success "Docker is accessible!"
  else
    print_warning "Docker command failed. Will use alternative diagnostics..."
    DEPLOY_METHOD="manual"
  fi
fi

print_info "Starting diagnostics for application..."

# System diagnostics
print_info "System information:"
uname -a
echo ""

print_info "Memory usage:"
free -h
echo ""

print_info "Disk usage:"
df -h | grep -v tmpfs
echo ""

# Network diagnostics
print_info "Network ports in use:"
netstat -tlnp 2>/dev/null | grep LISTEN || ss -tlnp 2>/dev/null || print_warning "Cannot check network ports"
echo ""

print_info "Network port $PORT status:"
netstat -tlnp 2>/dev/null | grep ":$PORT" || ss -tlnp 2>/dev/null | grep ":$PORT" || print_warning "Port $PORT not found in output"
echo ""

# Application diagnostics
if [ "$DEPLOY_METHOD" = "docker" ]; then
  print_info "Docker container status:"
  $DOCKER_CMD ps -a | grep "$CONTAINER_NAME" || print_warning "Container not found"
  echo ""
  
  print_info "Docker container logs (last 20 lines):"
  $DOCKER_CMD logs --tail 20 "$CONTAINER_NAME" 2>&1 || print_warning "Could not retrieve container logs"
  echo ""
  
  print_info "Docker container resource usage:"
  $DOCKER_CMD stats --no-stream "$CONTAINER_NAME" 2>&1 || print_warning "Could not get container stats"
  echo ""
else
  print_info "Application process status:"
  
  if command -v pm2 >/dev/null 2>&1; then
    print_info "PM2 status:"
    pm2 list | grep "$CONTAINER_NAME" || print_warning "Application not found in PM2"
    echo ""
    
    print_info "Application logs (last 20 lines):"
    pm2 logs --lines 20 "$CONTAINER_NAME" --nostream 2>/dev/null || print_warning "Could not retrieve application logs"
    echo ""
    
    print_info "PM2 process details:"
    pm2 show "$CONTAINER_NAME" 2>/dev/null || print_warning "Could not show process details"
    echo ""
  else
    print_info "Process using port $PORT:"
    lsof -i ":$PORT" 2>/dev/null || netstat -tlnp 2>/dev/null | grep ":$PORT" || print_warning "Cannot find process for port $PORT"
    echo ""
  fi
fi

# Application accessibility
print_info "Testing application HTTP access:"
curl -I "http://localhost:$PORT/" 2>/dev/null || print_warning "Could not connect to application"
echo ""

print_info "Diagnostics completed!"