# SSH Authentication Guide (optional diagnostics)

Production deploy **does not use SSH**. Deploy runs on a [self-hosted runner](self-hosted-runner-setup.md) on the VPS, which connects outbound to GitHub over HTTPS.

SSH secrets are only needed if you run the optional [ssh-diagnose.yml](../.github/workflows/ssh-diagnose.yml) workflow to test connectivity from GitHub-hosted runners (often blocked by Hostinger).

## Optional secrets (diagnostics only)

1. **VPS_SERVER** — VPS origin IP address (not `stellarpossible.com`; Cloudflare does not proxy SSH)
2. **VPS_USERNAME** — SSH username (e.g. `stellaruser`)
3. **SSH_PRIVATE_KEY** — Private deploy key (full content including headers, no passphrase)
4. **SSH_HOST_KEY** — Server host key (optional)
5. **VPS_PORT** — SSH port (default `22`)

## How to get the SSH host key

From your local machine:

```bash
ssh-keyscan -t ed25519,rsa,ecdsa YOUR_SERVER_IP_OR_HOSTNAME
```

Use only the algorithm + base64 blob (without the hostname) as `SSH_HOST_KEY` — the setup script prepends `VPS_SERVER`.

## Troubleshooting SSH diagnostics

1. Ensure the deploy key has no passphrase
2. Verify the public key is in `~/.ssh/authorized_keys` on the server for `VPS_USERNAME`
3. Use the VPS origin IP, not the Cloudflare-proxied domain
4. Connection timeouts from GitHub Actions are a firewall/network issue — use the self-hosted runner for deploy instead

## Production deploy

See [self-hosted-runner-setup.md](self-hosted-runner-setup.md) for installing the VPS runner (label `stellarpossible`).
