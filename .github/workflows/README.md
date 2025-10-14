# GitHub Actions Workflows

This directory contains GitHub Actions workflows for automating deployment and other tasks.

## 🚀 Deployment Workflow

The `release.yaml` workflow automates the deployment of the StellarPossible Nuxt.js application to a production or staging server.

### 🤖 What "Patchy" Does

The workflow, named "Patchy's Docker Deployment Adventure," performs the following steps:

1. **Code Checkout**: Retrieves the latest code from the repository
2. **Slack Notification**: Sends a deployment start notification to Slack
3. **Codebase Inspection**: Verifies that all required files exist
4. **Docker Build**: Builds a Docker image for the Nuxt.js application
5. **Container Testing**: Tests the container locally to ensure it works
6. **Image Packaging**: Saves the Docker image as a tar file
7. **Server Preparation**: Connects to the server and prepares it for deployment
8. **Image Upload**: Uploads the Docker image to the server
9. **Application Deployment**: Deploys the application on the server
10. **Health Checks**: Performs health checks to verify the deployment
11. **External Testing**: Tests the application from outside the server
12. **Diagnostics**: Runs final diagnostics to ensure everything is working
13. **Slack Notification**: Sends a success or failure notification to Slack

### 🔑 Required Secrets

The workflow requires the following secrets to be set in your GitHub repository:

- `VPS_SERVER`: The hostname or IP address of your server
- `VPS_USERNAME`: The SSH username for connecting to the server
- `SSH_PRIVATE_KEY`: Your private SSH key (full key content including headers)
- `SSH_HOST_KEY`: Your server's SSH host key (get it using `ssh-keyscan`)
- `SLACK_WEBHOOK_URL`: The Slack webhook URL for notifications
- `WP_APP_PASSWORD`: The WordPress application password
- `USE_JWT`: Whether to use JWT authentication
- `JWT_SECRET`: The JWT secret for authentication
- `ADMIN_EMAIL`: The admin email address

### 🐛 Troubleshooting Common Issues

#### SSH Connection Problems

If you see errors like `ssh: handshake failed` or `ssh: unable to authenticate`:

1. Verify your SSH keys are correctly set up:
   ```bash
   # On your local machine
   ssh-keyscan -t rsa YOUR_SERVER_IP > known_hosts_entry.txt
   # Add the content as SSH_HOST_KEY secret
   ```

2. Make sure your SSH private key is correctly formatted, including the BEGIN and END lines:
   ```
   -----BEGIN OPENSSH PRIVATE KEY-----
   ...key content...
   -----END OPENSSH PRIVATE KEY-----
   ```

3. Check that your public key is in the `~/.ssh/authorized_keys` file on the server.

#### Docker Container Issues

If the container fails to start:

1. Check for port conflicts on the server:
   ```bash
   sudo netstat -tlnp | grep :3000
   ```

2. View Docker logs:
   ```bash
   docker logs stellarpossible-app
   ```

3. Verify Docker permissions:
   ```bash
   sudo usermod -aG docker YOUR_USERNAME
   ```

#### Application Not Responding

If the application deploys but doesn't respond:

1. Check Nuxt.js server logs:
   ```bash
   docker logs stellarpossible-app
   ```

2. Verify environment variables:
   ```bash
   docker inspect -f '{{range .Config.Env}}{{println .}}{{end}}' stellarpossible-app
   ```

3. Test network connectivity:
   ```bash
   curl -v http://localhost:3000/
   ```

### 🧪 Testing the Workflow

You can manually trigger the workflow from the GitHub Actions tab by selecting "Run workflow" and choosing your target environment.

### 🔄 Customizing the Workflow

To customize the workflow:

1. Edit the `.github/workflows/release.yaml` file
2. Modify the environment variables at the top of the file
3. Add or remove steps as needed
4. Update the Slack notification content to match your preferences

For more advanced customization, refer to the [GitHub Actions documentation](https://docs.github.com/en/actions).