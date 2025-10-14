# Deployment Scripts

This directory contains modular scripts used in the GitHub Actions deployment workflow for the StellarPossible Nuxt.js application.

## 📝 Script Overview

### Core Scripts

- **setup-ssh.sh.obsolete**: [OBSOLETE] Former SSH setup script (kept for reference)
- **simple-ssh-setup.sh**: Simplified SSH setup that works with standard GitHub Actions secrets
- **build-image.sh**: Builds the Docker image for the Nuxt.js application
- **test-container.sh**: Tests the built Docker container to ensure it works correctly
- **prepare-server.sh**: Prepares the server for deployment (backup, cleanup, etc.)
- **deploy-app.sh**: Deploys the application to the server
- **health-check.sh**: Performs health checks on the deployed application

### Utility Scripts

The `utils/` directory contains shared utility functions:

- **slack-notify.sh**: Functions for sending Slack notifications
- **docker-utils.sh**: Helper functions for Docker operations

## 🚀 Using These Scripts

### In GitHub Actions

In the GitHub Actions workflow, scripts are called directly:

```yaml
- name: 🏗️ Patchy builds the Docker image
  run: |
    .github/scripts/build-image.sh
  env:
    IMAGE_NAME: ${{ env.DOCKER_IMAGE_NAME }}
    TAG: latest
    # Additional environment variables...
```

### On Remote Servers

For scripts that need to run on remote servers, the pattern is:

```yaml
- name: 🚚 Patchy prepares the server
  run: |
    ssh username@server "
      export VAR1=value1
      export VAR2=value2
      
      $(cat .github/scripts/prepare-server.sh)
    "
```

### Locally

For local testing, you can run:

```bash
# Make sure scripts are executable
chmod +x .github/scripts/*.sh
chmod +x .github/scripts/utils/*.sh

# Set environment variables
export IMAGE_NAME="stellarpossible-nuxt"
export TAG="test"

# Run a script
.github/scripts/build-image.sh
```

## ⚙️ Environment Variables

Each script requires specific environment variables. Here's a summary:

### setup-ssh.sh.obsolete [OBSOLETE]
- `SSH_PRIVATE_KEY`: The SSH private key
- `SERVER_HOST`: Hostname or IP of the server (no longer used)
- `SERVER_USER`: SSH username (no longer used)
- `SSH_HOST_KEY`: (Optional) Host key for verification

### simple-ssh-setup.sh
- `SSH_PRIVATE_KEY`: The SSH private key
- `VPS_SERVER`: Hostname or IP of the server (matches GitHub secret name)
- `VPS_USERNAME`: SSH username (matches GitHub secret name)
- `SSH_HOST_KEY`: (Optional) Host key for verification

### build-image.sh
- `IMAGE_NAME`: Name of the Docker image
- `TAG`: Tag for the Docker image
- `GIT_SHA`: Git SHA for versioning
- `SAVE_IMAGE`: Whether to save the image to a tar file

### test-container.sh
- `IMAGE_NAME`: Name of the Docker image
- `TAG`: Tag for the Docker image
- `TEST_PORT`: Port to use for testing
- `WAIT_TIME`: Time to wait for container startup
- `MAX_RETRIES`: Number of retry attempts

### prepare-server.sh
- `CONTAINER_NAME`: Name of the Docker container
- `IMAGE_NAME`: Name of the Docker image
- `DEPLOY_PATH`: Path on the server for deployment
- `APP_DIR`: Subdirectory for the application

### deploy-app.sh
- `CONTAINER_NAME`: Name of the Docker container
- `IMAGE_NAME`: Name of the Docker image
- `TAG`: Tag for the Docker image
- `DEPLOY_PATH`: Path on the server for deployment
- `APP_DIR`: Subdirectory for the application
- `TAR_FILE`: Docker image tar file
- Various application environment variables

### health-check.sh
- `CONTAINER_NAME`: Name of the Docker container
- `HOST`: Host to check (usually localhost)
- `PORT`: Port to check
- `RETRIES`: Number of retry attempts
- `DELAY`: Delay between retries

## 🛠️ Customizing Scripts

To customize a script:

1. Edit the script file directly
2. Update the environment variables as needed
3. Make sure the script remains executable (`chmod +x`)

For shared functionality, consider adding functions to the utility scripts.

## 🔒 Security Considerations

- Scripts handle sensitive information through environment variables
- SSH keys and secrets are never written to disk in plain text
- Error handling includes security considerations
- Scripts are designed to fail securely