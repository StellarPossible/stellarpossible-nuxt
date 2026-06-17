# Self-hosted GitHub Actions runner (StellarPossible VPS)

Production deploy uses a **self-hosted runner** on the VPS so GitHub never needs inbound SSH from `ubuntu-latest` runners (Hostinger often blocks those IPs).

The runner pulls jobs over **outbound HTTPS** to GitHub. The `quality` job runs on GitHub-hosted runners; the `deploy` job runs on your server.

## Requirements

- VPS with Docker (same host as the StellarPossible site; often shared with RollCall)
- Linux user with Docker access (e.g. `stellaruser`)
- Deploy tree at `/var/www/stellarpossible.com/nuxt-app`

## Coexistence with RollCall

RollCall uses a separate runner in `~/actions-runner` with label `rollcall`. StellarPossible uses:

| Setting | Value |
|---------|--------|
| Directory | `~/actions-runner-stellarpossible` |
| Label | `stellarpossible` |
| Runner name | `stellarpossible-vps` |

Both runners can run on the same VPS without conflict.

## Get the registration token (GitHub UI)

GitHub does **not** show a separate “Copy token” button. On **Settings → Actions → Runners → New self-hosted runner → Linux**, use the **Configure** block:

```bash
./config.sh --url https://github.com/StellarPossible/stellarpossible-nuxt --token YOUR_TOKEN_HERE
```

Copy **only** the string after `--token` (no quotes). It expires in about one hour.

Do **not** stop after GitHub’s `./run.sh` step alone — that omits the custom label **`stellarpossible`** and does not install a systemd service. Use the install script below.

## Install on the VPS (recommended)

1. **New self-hosted runner → Linux** — copy the `--token` value from **Configure** (see above)
2. On the VPS as `stellaruser`:

```bash
git clone https://github.com/StellarPossible/stellarpossible-nuxt.git
cd stellarpossible-nuxt
export REGISTRATION_TOKEN='paste-value-after--token'
chmod +x scripts/install-actions-runner.sh
./scripts/install-actions-runner.sh
```

The script downloads the runner, registers with labels `self-hosted,linux,stellarpossible`, and installs a systemd service.

## Manual install

Run on the VPS as the deploy user:

```bash
mkdir -p ~/actions-runner-stellarpossible && cd ~/actions-runner-stellarpossible

curl -o actions-runner-linux-x64.tar.gz -L \
  https://github.com/actions/runner/releases/download/v2.334.0/actions-runner-linux-x64-2.334.0.tar.gz
tar xzf actions-runner-linux-x64.tar.gz
```

Register:

```bash
cd ~/actions-runner-stellarpossible
./config.sh --url https://github.com/StellarPossible/stellarpossible-nuxt --token YOUR_TOKEN \
  --name stellarpossible-vps \
  --labels self-hosted,linux,stellarpossible \
  --unattended
```

Labels must include **`stellarpossible`** — the deploy workflow uses `runs-on: [self-hosted, linux, stellarpossible]`.

Run as a service:

```bash
cd ~/actions-runner-stellarpossible
sudo ./svc.sh install stellaruser
sudo ./svc.sh start
sudo ./svc.sh status
```

Replace `stellaruser` with your deploy user.

## Verify

| Check | Expected |
|-------|----------|
| **Settings → Actions → Runners** | Runner **Idle** (green) |
| Labels | `self-hosted`, `Linux`, `stellarpossible` |
| Workflow | `quality` succeeds on GitHub, `deploy` starts on the VPS runner within seconds |

Re-run **Patchy's Docker Deployment Adventure** or push to `main`.

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Deploy job stuck “Waiting for a runner” | Runner not installed or offline — run [install-actions-runner.sh](../scripts/install-actions-runner.sh), confirm **Idle** in GitHub, then `cd ~/actions-runner-stellarpossible && sudo ./svc.sh start` |
| `docker: permission denied` | `sudo usermod -aG docker stellaruser` then re-login |
| Artifact download fails | Check disk space under `~/actions-runner-stellarpossible/_work` |
| Wrong labels | Re-configure: `./config.sh --labels self-hosted,linux,stellarpossible --replace` with a new token |

## Optional: SSH secrets

After the self-hosted path is stable, `SSH_PRIVATE_KEY`, `VPS_SERVER`, and `VPS_USERNAME` are not required for production deploy (keep them for [ssh-diagnose.yml](../.github/workflows/ssh-diagnose.yml) if needed).

## Updating the runner

```bash
cd ~/actions-runner-stellarpossible
sudo ./svc.sh stop
# Download newer actions-runner-linux-x64.tar.gz, extract over existing files
sudo ./svc.sh start
```
