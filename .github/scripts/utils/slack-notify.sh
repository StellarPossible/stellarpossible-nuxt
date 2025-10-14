#!/bin/bash
#
# Slack Notification Utilities
# This script provides functions for sending notifications to Slack.
#

# Default values
SLACK_USERNAME=${SLACK_USERNAME:-"Patchy the GitHub Bot"}
SLACK_ICON=${SLACK_ICON:-":robot_face:"}
SLACK_CHANNEL=${SLACK_CHANNEL:-"#deployments"}

# Print colorful messages
print_info() {
  echo -e "\033[36m💬 [SLACK] $1\033[0m"
}

print_success() {
  echo -e "\033[32m✅ [SLACK] $1\033[0m"
}

print_error() {
  echo -e "\033[31m❌ [SLACK] $1\033[0m"
  return 1
}

# Function to check if Slack webhook URL is set
check_slack_webhook() {
  if [ -z "$SLACK_WEBHOOK_URL" ]; then
    print_error "SLACK_WEBHOOK_URL environment variable is not set!"
    return 1
  fi
  return 0
}

# Function to send a simple message to Slack
send_slack_message() {
  local message="$1"
  
  if ! check_slack_webhook; then
    print_info "Slack notifications disabled (no webhook URL)"
    return 0
  fi
  
  print_info "Sending message to Slack..."
  
  curl -s -X POST -H 'Content-type: application/json' \
    --data "{\"text\":\"$message\", \"username\":\"$SLACK_USERNAME\", \"icon_emoji\":\"$SLACK_ICON\", \"channel\":\"$SLACK_CHANNEL\"}" \
    "$SLACK_WEBHOOK_URL" > /dev/null
    
  print_success "Message sent!"
}

# Function to send a deployment start notification
send_deployment_start() {
  local env="${1:-production}"
  local repo="${2:-unknown}"
  local actor="${3:-unknown}"
  local sha="${4:-unknown}"
  
  if ! check_slack_webhook; then
    print_info "Slack notifications disabled (no webhook URL)"
    return 0
  fi
  
  print_info "Sending deployment start notification..."
  
  local payload="{
    \"text\": \"🤖 *Patchy the GitHub Bot* is starting a new deployment mission!\",
    \"attachments\": [
      {
        \"color\": \"#36a64f\",
        \"fields\": [
          {
            \"title\": \"🎯 Mission Target\",
            \"value\": \"$env\",
            \"short\": true
          },
          {
            \"title\": \"📦 Package\",
            \"value\": \"$repo\",
            \"short\": true
          },
          {
            \"title\": \"🔧 Triggered by\",
            \"value\": \"$actor\",
            \"short\": true
          },
          {
            \"title\": \"📝 Commit\",
            \"value\": \"<https://github.com/$repo/commit/$sha|$sha> by $actor\",
            \"short\": true
          }
        ],
        \"footer\": \"Patchy is feeling confident about this one! 🎯\"
      }
    ]
  }"
  
  curl -s -X POST -H 'Content-type: application/json' \
    --data "$payload" \
    "$SLACK_WEBHOOK_URL" > /dev/null
    
  print_success "Deployment start notification sent!"
}

# Function to send a deployment success notification
send_deployment_success() {
  local env="${1:-production}"
  local repo="${2:-unknown}"
  local actor="${3:-unknown}"
  local sha="${4:-unknown}"
  
  if ! check_slack_webhook; then
    print_info "Slack notifications disabled (no webhook URL)"
    return 0
  fi
  
  print_info "Sending deployment success notification..."
  
  local timestamp=$(date -u +'%Y-%m-%d %H:%M:%S UTC')
  
  local payload="{
    \"text\": \"🎉 *Patchy the GitHub Bot* has successfully completed the deployment mission!\",
    \"attachments\": [
      {
        \"color\": \"#36a64f\",
        \"fields\": [
          {
            \"title\": \"🎯 Mission Status\",
            \"value\": \"✅ SUCCESSFUL DEPLOYMENT\",
            \"short\": true
          },
          {
            \"title\": \"🌐 Application\",
            \"value\": \"Running on port 3000\",
            \"short\": true
          },
          {
            \"title\": \"📦 Version\",
            \"value\": \"\`$sha\`\",
            \"short\": true
          },
          {
            \"title\": \"⏱️ Deployment Time\",
            \"value\": \"$timestamp\",
            \"short\": true
          },
          {
            \"title\": \"🔧 Deployed by\",
            \"value\": \"$actor\",
            \"short\": true
          },
          {
            \"title\": \"🎯 Environment\",
            \"value\": \"$env\",
            \"short\": true
          }
        ],
        \"footer\": \"Patchy is doing a happy robot dance! 🤖💃 Container is running smoothly!\",
        \"footer_icon\": \"https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png\"
      }
    ]
  }"
  
  curl -s -X POST -H 'Content-type: application/json' \
    --data "$payload" \
    "$SLACK_WEBHOOK_URL" > /dev/null
    
  print_success "Deployment success notification sent!"
}

# Function to send a deployment failure notification
send_deployment_failure() {
  local env="${1:-production}"
  local repo="${2:-unknown}"
  local actor="${3:-unknown}"
  local sha="${4:-unknown}"
  local run_id="${5:-unknown}"
  
  if ! check_slack_webhook; then
    print_info "Slack notifications disabled (no webhook URL)"
    return 0
  fi
  
  print_info "Sending deployment failure notification..."
  
  local timestamp=$(date -u +'%Y-%m-%d %H:%M:%S UTC')
  
  local payload="{
    \"text\": \"😱 *Patchy the GitHub Bot* encountered a problem during deployment!\",
    \"attachments\": [
      {
        \"color\": \"#ff0000\",
        \"fields\": [
          {
            \"title\": \"🚨 Mission Status\",
            \"value\": \"❌ DEPLOYMENT FAILED\",
            \"short\": true
          },
          {
            \"title\": \"📦 Failed Version\",
            \"value\": \"\`$sha\`\",
            \"short\": true
          },
          {
            \"title\": \"🔧 Attempted by\",
            \"value\": \"$actor\",
            \"short\": true
          },
          {
            \"title\": \"⏱️ Failed at\",
            \"value\": \"$timestamp\",
            \"short\": true
          },
          {
            \"title\": \"🎯 Target Environment\",
            \"value\": \"$env\",
            \"short\": true
          },
          {
            \"title\": \"📊 Workflow Run\",
            \"value\": \"<https://github.com/$repo/actions/runs/$run_id|View Details>\",
            \"short\": true
          }
        ],
        \"footer\": \"Patchy is feeling a bit glitchy... 🤖💥 Time to debug!\",
        \"footer_icon\": \"https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png\"
      }
    ]
  }"
  
  curl -s -X POST -H 'Content-type: application/json' \
    --data "$payload" \
    "$SLACK_WEBHOOK_URL" > /dev/null
    
  print_success "Deployment failure notification sent!"
}