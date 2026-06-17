# GitHub Actions Workflows

This directory contains GitHub Actions workflows for automating deployment and other tasks.

## Workflows

| Workflow | File | Triggers |
|----------|------|----------|
| Production deploy | `release.yaml` | Push to `main`, GitHub release, manual dispatch |
| SSH diagnose | `ssh-diagnose.yml` | Manual only — test SSH from GitHub-hosted runner (optional) |

## Production deploy flow

Production deploy uses a **self-hosted runner** on the VPS (labels: `self-hosted`, `linux`, `stellarpossible`). Install once: [docs/self-hosted-runner-setup.md](../../docs/self-hosted-runner-setup.md).

| Job | Runner | Steps |
|-----|--------|--------|
| `quality` | `ubuntu-latest` | Typecheck, lint |
| `deploy` | `self-hosted` on VPS | Build Docker image, smoke test, prepare server, deploy, health checks |

The deploy job runs **on the VPS** — no `scp` or `ssh` from GitHub cloud runners (Hostinger often blocks inbound SSH from Actions).

If the VPS runner is missing or offline, the `deploy` job stays on **Waiting for a runner** until an online runner with label `stellarpossible` is available. Confirm **Settings → Actions → Runners** shows **Idle** before expecting deploy to start.

Overlapping deploys are **queued** (`concurrency: stellarpossible-production-deploy`).

## Project structure

```
.github/
├── workflows/
│   ├── release.yaml         # Main workflow file
│   ├── ssh-diagnose.yml     # Optional SSH connectivity test
│   └── README.md
└── scripts/
    ├── simple-ssh-setup.sh  # SSH setup (diagnostics only)
    ├── build-image.sh
    ├── test-container.sh
    ├── prepare-server.sh
    ├── deploy-app.sh
    ├── health-check.sh
    └── utils/
        └── slack-notify.sh
scripts/
└── install-actions-runner.sh  # One-time VPS runner install
```

## What "Patchy" does

1. **Quality gate** (GitHub cloud): checkout, `npm ci`, typecheck, lint
2. **Deploy** (VPS runner): Slack notification, Docker build, container test
3. Stage image tarball to `/var/www/stellarpossible.com/nuxt-app`
4. Prepare server, deploy application, health checks
5. External URL test and diagnostics
6. Slack success or failure notification

## Required GitHub secrets

Configure under **Settings → Secrets and variables → Actions** (or the `production` / `staging` environment).

| Secret | Description |
|--------|-------------|
| `WP_APP_PASSWORD` | WordPress application password |
| `USE_JWT` | Whether to use JWT authentication |
| `JWT_SECRET` | JWT secret for authentication |
| `ADMIN_EMAIL` | Admin email address |
| `STRIPE_SECRET_KEY` | Stripe secret key |
| `STRIPE_PRICE_MONTHLY` | Stripe monthly price ID |
| `STRIPE_PRICE_ANNUAL` | Stripe annual price ID |
| `NUXT_PUBLIC_SITE_URL` | Public site URL |
| `SLACK_WEBHOOK_URL` | Optional deploy notifications |

SSH secrets (`VPS_SERVER`, `VPS_USERNAME`, `SSH_PRIVATE_KEY`, `SSH_HOST_KEY`, `VPS_PORT`) are **optional** — only needed for the [ssh-diagnose.yml](ssh-diagnose.yml) workflow.

## VPS one-time bootstrap

1. Ensure deploy tree exists at `/var/www/stellarpossible.com/nuxt-app` and user has Docker access
2. Install self-hosted runner: [docs/self-hosted-runner-setup.md](../../docs/self-hosted-runner-setup.md)
3. Confirm runner is **Idle** with label `stellarpossible`
4. Run **Patchy's Docker Deployment Adventure** manually or push to `main`

## Troubleshooting

### Deploy stuck "Waiting for a runner"

Runner not installed or offline. On the VPS:

```bash
cd ~/actions-runner-stellarpossible
sudo ./svc.sh status
sudo ./svc.sh start
```

Re-install if needed: [scripts/install-actions-runner.sh](../../scripts/install-actions-runner.sh)

### SSH (diagnostics only)

Run **SSH connectivity diagnose** manually. If you see connection timeouts from GitHub-hosted runners, that is expected on Hostinger — production deploy does not use SSH.

For SSH secret setup and host keys, see [docs/ssh-authentication-guide.md](../../docs/ssh-authentication-guide.md).

Set `SSH_DEBUG=1` in the workflow env to get `ssh -vvv` output from `simple-ssh-setup.sh`.

### Docker container issues

```bash
sudo netstat -tlnp | grep :3000
docker logs stellarpossible-app
sudo usermod -aG docker stellaruser
```

### Application not responding

```bash
docker logs stellarpossible-app
docker inspect -f '{{range .Config.Env}}{{println .}}{{end}}' stellarpossible-app
curl -v http://localhost:3000/
```

## Manual deploy

Actions → **Patchy's Docker Deployment Adventure** → **Run workflow** (requires idle self-hosted runner).

## Working with scripts locally

```bash
.github/scripts/build-image.sh
.github/scripts/test-container.sh
```

For more advanced customization, refer to the [GitHub Actions documentation](https://docs.github.com/en/actions).
