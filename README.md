# Calibre-Web CI/CD Practice

Practice project for building a CI/CD pipeline around Calibre-Web using GitHub Actions, Docker, and a self-managed VPS.

> Focus of this repository: deployment automation and container workflow, not the application itself.

---

# Stack

- GitHub Actions
- Docker & Docker Compose
- Docker Hub
- Ubuntu VPS
- SSH Deployment

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
SSH into VPS
    ↓
Pull new image & redeploy
```

---

# Features

- Multi-job GitHub Actions workflow
- Docker image tagging with commit SHA
- Automatic deployment to VPS
- Docker layer caching with `type=gha`
- Environment-based image versioning
- Separate `test` and `deploy` stages

---

# Image Tagging Strategy

Each deployment pushes two tags:

```text
latest
<commit-sha>
```

Using the commit SHA makes deployments traceable and allows rollback to a specific version if needed.

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
```

---

# Notes

- Deploy only runs after the test job succeeds
- Deployments are triggered only from `main`
- `docker-compose.yml` reads `IMAGE_TAG` dynamically during deployment
- Lint/tests currently use `continue-on-error: true` since the main goal of this repo is CI/CD practice

---

# What I Practiced

- Building multi-stage GitHub Actions workflows
- SSH-based deployment automation
- Docker image versioning strategies
- CI/CD environment variable handling
- Debugging Docker Compose image resolution issues
- Applying least-privilege permissions in GitHub Actions
