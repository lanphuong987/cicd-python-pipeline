# Calibre-Web CI/CD Practice

CI/CD practice project using Calibre-Web, GitHub Actions, Docker, Docker Hub, and a self-managed VPS.

Main focus of this repository is deployment automation and container workflow, not the application itself.

---

# Stack

- GitHub Actions
- Docker & Docker Compose
- Docker Hub
- Ubuntu VPS
- SSH Deployment
- Trivy
- Telegram Bot

---

# Pipeline Flow

```text
Push to main
    ↓
Run lint + tests
    ↓
Build Docker image
    ↓
Push image to Docker Hub
    ↓
Run Trivy scan
    ↓
SSH into VPS
    ↓
Pull new image
    ↓
Redeploy container
    ↓
Run health check
    ↓
Rollback automatically if unhealthy
```

---

# Features

- Multi-job GitHub Actions workflow
- Separate test and deploy stages
- Docker image tagging with commit SHA
- Automatic VPS deployment via SSH
- Docker layer caching with `type=gha`
- Health check after deployment
- Automatic rollback on failed deployment
- Telegram notification on deployment failure
- Trivy image security scanning
- GitHub Environment protection
- Least-privilege GitHub Actions permissions

---

# Image Tagging Strategy

Each deployment pushes 2 image tags:

```text
latest
<commit-sha>
```

Example:

```text
lanphuong2000/calibre-web:latest
lanphuong2000/calibre-web:a1b2c3d
```

Using commit SHA tags makes deployments traceable and easier to rollback.

---

# Rollback Strategy

Before deployment, the current image tag is stored in:

```text
.current_tag
```

If the new container fails health checks:

- deployment is marked as failed
- previous image is redeployed automatically
- GitHub Actions exits with failure status
- Telegram notification is sent

---

# Health Check Flow

```text
docker compose up -d
        ↓
Check container health status
        ↓
healthy → deployment success
unhealthy → rollback
```

The workflow waits up to 10 checks before marking the deployment as failed.

---

# Security Scan

Docker images are scanned using Trivy.

Current configuration does not fail the pipeline on vulnerabilities:

```yaml
exit-code: "0"
```

Reason:
This project uses multiple open-source Python dependencies, so the scan is currently informational for CI/CD practice purposes.

---

# Repository Structure

```text
.
├── .github/workflows/deploy.yml
├── docker-compose.yml
├── Dockerfile
├── requirements.txt
└── ...
```

---

# Required GitHub Secrets

```text
DOCKER_USERNAME
DOCKER_ACCESS_TOKEN

SERVER_IP
SERVER_USER
SERVER_SSH_KEY

TELEGRAM_CHAT_ID
TELEGRAM_BOT_TOKEN
```

---

# Deployment Rules

- Deployments only run from `main`
- Deploy job only starts after test job succeeds
- Production deployment uses GitHub Environment protection
- `docker-compose.yml` reads `IMAGE_TAG` dynamically during deployment

---

# Notes

- `flake8` and `pytest` currently use `continue-on-error: true`
- Trivy scan is non-blocking for learning purposes
- Docker images are cleaned after successful deployment using:

```bash
docker image prune -f
```

---

# What I Practiced

- Building multi-stage GitHub Actions workflows
- SSH-based deployment automation
- Docker image versioning
- Automatic rollback handling
- Container health monitoring
- Security scanning with Trivy
- CI/CD environment variable handling
- Docker layer caching
- Telegram failure notification
- Applying least-privilege permissions in GitHub Actions
- Debugging Docker Compose deployment issues

