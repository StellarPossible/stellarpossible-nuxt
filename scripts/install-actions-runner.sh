#!/usr/bin/env bash
#
# One-time GitHub Actions self-hosted runner install for StellarPossible production deploy.
# Run ON THE VPS as the deploy user (Docker access).
#
#   GitHub → Settings → Actions → Runners → New self-hosted runner → Linux
#   Under Configure, copy the value after --token from the config.sh line (no separate copy button)
#   export REGISTRATION_TOKEN='that-token-value'   # expires in ~1 hour
#   ./scripts/install-actions-runner.sh
#
set -euo pipefail

RUNNER_VERSION="${RUNNER_VERSION:-2.334.0}"
REPO_URL="${REPO_URL:-https://github.com/StellarPossible/stellarpossible-nuxt}"
RUNNER_NAME="${RUNNER_NAME:-stellarpossible-vps}"
RUNNER_DIR="${RUNNER_DIR:-$HOME/actions-runner-stellarpossible}"
RUNNER_USER="${RUNNER_USER:-$(whoami)}"
RUNNER_LABELS="${RUNNER_LABELS:-self-hosted,linux,stellarpossible}"

print_step() { echo -e "\n\033[36m==> $1\033[0m"; }
print_ok() { echo -e "\033[32mOK: $1\033[0m"; }
print_err() { echo -e "\033[31mERROR: $1\033[0m" >&2; exit 1; }

if [ -z "${REGISTRATION_TOKEN:-}" ]; then
  print_err "Set REGISTRATION_TOKEN to the value after --token in the Configure step (Settings → Actions → Runners → New self-hosted runner → Linux)."
fi

if ! command -v curl >/dev/null 2>&1; then
  print_err "curl is required"
fi

ARCHIVE="actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"
DOWNLOAD_URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/${ARCHIVE}"

print_step "Prepare runner directory ($RUNNER_DIR)"
mkdir -p "$RUNNER_DIR"
cd "$RUNNER_DIR"

if [ -f ./config.sh ] && [ -f ./run.sh ]; then
  print_ok "Existing runner files found — re-configuring labels if needed"
else
  print_step "Download runner v${RUNNER_VERSION}"
  curl -fsSL -o "$ARCHIVE" "$DOWNLOAD_URL"
  tar xzf "$ARCHIVE"
  rm -f "$ARCHIVE"
  print_ok "Extracted runner"
fi

print_step "Register runner ($RUNNER_NAME) → $REPO_URL"
./config.sh --url "$REPO_URL" --token "$REGISTRATION_TOKEN" \
  --name "$RUNNER_NAME" \
  --labels "$RUNNER_LABELS" \
  --unattended \
  --replace

print_step "Install systemd service (user: $RUNNER_USER)"
if [ -f ./svc.sh ]; then
  sudo ./svc.sh install "$RUNNER_USER" || print_err "svc.sh install failed (run with sudo access)"
  sudo ./svc.sh start
  sudo ./svc.sh status || true
  print_ok "Runner service started"
else
  print_err "svc.sh not found in $RUNNER_DIR"
fi

echo ""
print_ok "Next: GitHub → Settings → Actions → Runners — status should be Idle with labels: $RUNNER_LABELS"
print_ok "Then re-run Patchy's Docker Deployment Adventure or push to main"
