# GitHub Configuration

This directory contains GitHub Actions workflows and deployment scripts for the StellarPossible Nuxt.js application.

## 📁 Structure

- **workflows/**: Contains GitHub Actions workflow files
  - `release.yaml`: Main deployment workflow
  - `release.yaml.old-version`: Previous version of the workflow (kept for reference)
  
- **scripts/**: Contains modular deployment scripts
  - Core scripts for deployment tasks
  - `utils/` directory with shared utility functions
  - `setup-ssh.sh.obsolete`: Old SSH setup script (kept for reference)
  - `simple-ssh-setup.sh`: Current SSH setup script used in the workflow

## 📚 Documentation

- See `workflows/README.md` for detailed workflow documentation
- See `scripts/README.md` for documentation on individual scripts

## 🔄 Recent Changes

- Updated SSH setup to use `simple-ssh-setup.sh` which aligns with standard GitHub secrets naming
- Implemented a modular script architecture for better maintainability
- Added comprehensive error handling and debugging capabilities
- Included Slack notifications for deployment status updates

## 🧪 Testing

The workflow can be manually triggered from the GitHub Actions tab using the workflow_dispatch event.