#!/bin/bash
#
# SSH Setup Script for GitHub Actions (diagnostics only — production deploy uses self-hosted runner)
#

set -e

DEPLOY_SSH_HOST="${DEPLOY_SSH_HOST:-stellarpossible-deploy}"
VPS_PORT="${VPS_PORT:-22}"
SSH_CONNECT_TIMEOUT="${SSH_CONNECT_TIMEOUT:-30}"
SSH_MAX_ATTEMPTS="${SSH_MAX_ATTEMPTS:-5}"
SSH_RETRY_DELAYS=(5 10 15 20 25)

print_info() { echo -e "\033[36m🔑 [SSH SETUP] $1\033[0m"; }
print_success() { echo -e "\033[32m✅ [SSH SETUP] $1\033[0m"; }
print_error() { echo -e "\033[31m❌ [SSH SETUP] $1\033[0m"; exit 1; }

[ -n "$SSH_PRIVATE_KEY" ] || print_error "SSH_PRIVATE_KEY is not set!"
[ -n "$VPS_SERVER" ] || print_error "VPS_SERVER is not set!"
[ -n "$VPS_USERNAME" ] || print_error "VPS_USERNAME is not set!"

VPS_SERVER="${VPS_SERVER#https://}"
VPS_SERVER="${VPS_SERVER#http://}"
VPS_SERVER="${VPS_SERVER%%/*}"
VPS_SERVER="$(printf '%s' "$VPS_SERVER" | tr -d '[:space:]')"
VPS_USERNAME="$(printf '%s' "$VPS_USERNAME" | tr -d '[:space:]')"
VPS_PORT="$(printf '%s' "$VPS_PORT" | tr -d '[:space:]')"

mkdir -p ~/.ssh
chmod 700 ~/.ssh

DEPLOY_KEY="$HOME/.ssh/id_deploy"
KEY_RAW="$(printf '%s' "$SSH_PRIVATE_KEY" | tr -d '\r')"
if printf '%s' "$KEY_RAW" | grep -q '\\n'; then
  printf '%s' "$KEY_RAW" | sed 's/\\n/\n/g' > "$DEPLOY_KEY"
else
  printf '%s\n' "$KEY_RAW" > "$DEPLOY_KEY"
fi
chmod 600 "$DEPLOY_KEY"

if ! grep -q 'BEGIN .*PRIVATE KEY' "$DEPLOY_KEY"; then
  print_error "SSH_PRIVATE_KEY does not look like a PEM private key (missing BEGIN … PRIVATE KEY)."
fi

if ! ssh-keygen -y -f "$DEPLOY_KEY" > "$HOME/.ssh/id_deploy.pub" 2>/dev/null; then
  print_error "SSH_PRIVATE_KEY is invalid or corrupted. Re-save the secret with: gh secret set SSH_PRIVATE_KEY < ~/.ssh/your_deploy_key"
fi
chmod 644 "$HOME/.ssh/id_deploy.pub"

touch ~/.ssh/known_hosts
chmod 644 ~/.ssh/known_hosts
if [ -n "$SSH_HOST_KEY" ]; then
  echo "$VPS_SERVER $SSH_HOST_KEY" >> ~/.ssh/known_hosts
  HOST_KEY_POLICY=yes
else
  HOST_KEY_POLICY=accept-new
fi

SSH_COMMON_OPTS="ConnectTimeout=${SSH_CONNECT_TIMEOUT} ConnectionAttempts=3 ServerAliveInterval=15 ServerAliveCountMax=3 BatchMode=yes"

cat > ~/.ssh/config << EOF
Host ${DEPLOY_SSH_HOST}
  HostName ${VPS_SERVER}
  Port ${VPS_PORT}
  User ${VPS_USERNAME}
  IdentityFile ${DEPLOY_KEY}
  IdentitiesOnly yes
  StrictHostKeyChecking ${HOST_KEY_POLICY}
  UserKnownHostsFile ~/.ssh/known_hosts
  ConnectTimeout ${SSH_CONNECT_TIMEOUT}
  ConnectionAttempts 3
  ServerAliveInterval 15
  ServerAliveCountMax 3
  LogLevel ERROR

Host ${VPS_SERVER}
  HostName ${VPS_SERVER}
  Port ${VPS_PORT}
  User ${VPS_USERNAME}
  IdentityFile ${DEPLOY_KEY}
  IdentitiesOnly yes
  StrictHostKeyChecking ${HOST_KEY_POLICY}
  UserKnownHostsFile ~/.ssh/known_hosts
  ConnectTimeout ${SSH_CONNECT_TIMEOUT}
  ConnectionAttempts 3
  ServerAliveInterval 15
  ServerAliveCountMax 3
  LogLevel ERROR

Host *
  StrictHostKeyChecking accept-new
  UserKnownHostsFile ~/.ssh/known_hosts
  LogLevel ERROR
EOF
chmod 644 ~/.ssh/config

print_info "Private key:"
ssh-keygen -lf "$DEPLOY_KEY" || print_info "Could not read key fingerprint"
print_info "Public key (must appear in ~${VPS_USERNAME}/.ssh/authorized_keys on the VPS):"
cat "$HOME/.ssh/id_deploy.pub"
print_info "Target: ${VPS_USERNAME}@${VPS_SERVER}:${VPS_PORT} (ssh alias: ${DEPLOY_SSH_HOST})"

if [ -n "${GITHUB_ENV:-}" ]; then
  echo "DEPLOY_SSH_HOST=${DEPLOY_SSH_HOST}" >> "$GITHUB_ENV"
  echo "GIT_SSH_COMMAND=ssh -o ${SSH_COMMON_OPTS// / -o } -i ${DEPLOY_KEY} -o IdentitiesOnly=yes" >> "$GITHUB_ENV"
fi

SSH_OPTS=(-o "ConnectTimeout=${SSH_CONNECT_TIMEOUT}" -o ConnectionAttempts=3 -o ServerAliveInterval=15 -o ServerAliveCountMax=3 -o BatchMode=yes)
if [ "${SSH_DEBUG:-}" = "1" ]; then
  SSH_OPTS+=(-vvv)
fi

LAST_SSH_OUTPUT=""
attempt_ssh() {
  local err_file
  err_file="$(mktemp)"
  if ssh "${SSH_OPTS[@]}" "$DEPLOY_SSH_HOST" "echo 'SSH connection successful'" 2>"$err_file"; then
    rm -f "$err_file"
    return 0
  fi
  LAST_SSH_OUTPUT="$(cat "$err_file")"
  rm -f "$err_file"
  return 1
}

print_info "Connecting (up to ${SSH_MAX_ATTEMPTS} attempts, ${SSH_CONNECT_TIMEOUT}s timeout each)..."
connected=0
for attempt in $(seq 1 "$SSH_MAX_ATTEMPTS"); do
  if attempt_ssh; then
    print_success "SSH connection established (attempt ${attempt}/${SSH_MAX_ATTEMPTS})!"
    connected=1
    break
  fi
  echo "$LAST_SSH_OUTPUT" | tail -5
  if [ "$attempt" -lt "$SSH_MAX_ATTEMPTS" ]; then
    delay="${SSH_RETRY_DELAYS[$((attempt - 1))]:-15}"
    print_info "Attempt ${attempt}/${SSH_MAX_ATTEMPTS} failed — retrying in ${delay}s..."
    sleep "$delay"
  fi
done

if [ "$connected" -ne 1 ]; then
  echo ""
  if echo "$LAST_SSH_OUTPUT" | grep -qiE 'timed out|timeout|no route|network is unreachable|connection refused'; then
    print_error "SSH connection timed out or was unreachable (${VPS_USERNAME}@${VPS_SERVER}:${VPS_PORT}).

This is a network/firewall issue, not SSH keys. Check:
  - VPS_SERVER is the VPS origin IP, NOT stellarpossible.com (Cloudflare does not proxy SSH)
  - Hostinger / ufw allows inbound TCP ${VPS_PORT} from the public internet
  - fail2ban has not banned GitHub Actions runner IPs: sudo fail2ban-client status sshd
  - Production deploy no longer requires SSH — use the self-hosted runner (see docs/self-hosted-runner-setup.md)

Last ssh output:
${LAST_SSH_OUTPUT}"
  elif echo "$LAST_SSH_OUTPUT" | grep -qiE 'permission denied|publickey'; then
    print_error "SSH authentication failed for ${VPS_USERNAME}@${VPS_SERVER}.

On the VPS, as a sudo user, run:
  mkdir -p ~${VPS_USERNAME}/.ssh && chmod 700 ~${VPS_USERNAME}/.ssh
  echo '<paste the public key line printed above>' >> ~${VPS_USERNAME}/.ssh/authorized_keys
  chmod 600 ~${VPS_USERNAME}/.ssh/authorized_keys
  chown -R ${VPS_USERNAME}:${VPS_USERNAME} ~${VPS_USERNAME}/.ssh

Also verify GitHub secrets VPS_USERNAME, VPS_SERVER, and SSH_PRIVATE_KEY.

Last ssh output:
${LAST_SSH_OUTPUT}"
  else
    print_error "Failed to establish SSH connection after ${SSH_MAX_ATTEMPTS} attempts.

Verify VPS_SERVER (origin IP), VPS_USERNAME, VPS_PORT (${VPS_PORT}), and firewall rules.

Last ssh output:
${LAST_SSH_OUTPUT}"
  fi
fi

print_success "SSH setup completed!"
