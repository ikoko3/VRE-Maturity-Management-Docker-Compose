# VRE Maturity Management — Docker Compose

Spin up the full demo stack (Keycloak, MongoDB, Backend, Frontend) locally with one command.  
**Purpose:** provide a ready-to-run environment to **test and evaluate** the Virtual Labs Readiness/Maturity project (POC). All data is pre-seeded and stored **inside** containers (ephemeral).

---

## What’s included

- **Keycloak** (dev mode) — realm imported on startup
- **MongoDB** — pre-seeded from BSON dump on first run
- **Backend API** — Node/TS service (Swagger enabled)
- **Frontend** — Next.js app

---

## Prerequisites

- Docker Desktop (or Docker Engine) with **docker compose v2**
- Internet access to pull images from GHCR (GitHub Container Registry)

> If the GHCR packages are **private**, log in first:
>
> ```powershell
> $sec = Read-Host "Paste your GHCR Personal Access Token (read:packages)" -AsSecureString
> $pat = [System.Net.NetworkCredential]::new("", $sec).Password
> $pat | docker login ghcr.io -u <your-github-username> --password-stdin
> ```

---

## Quick start

```bash
docker compose pull
docker compose up -d
```

### URLs

- **Frontend**: http://localhost:4000  
- **Backend (Swagger)**: http://localhost:3000/api-docs  
- **Keycloak Admin**: http://localhost:8080/

### Demo users (for app login)

```
coordinator@test.com
myuser@test.com
developer@test.com
```
```
Password (all): 123
```

> These accounts are for **demo/testing only**. 

### Keycloak admin (bootstrap)

```
Username: admin
Password: change_me
```

### Notes on user permissions

There are 2 layers of user permissions. The lab related roles can be assigned via the application on each lab. The VRE "global" roles are specified via the Keycloak admin platform. 

---

## How it works (POC mode)

- **Keycloak** starts in `start-dev` and imports realm JSON embedded in the image.
- **MongoDB** restores a BSON archive on the first start (when data dir is empty).
- **No volumes** are mounted: stopping and starting the stack resets it to a clean, pre-seeded state.

**Reset to a clean slate:**
```bash
docker compose down
docker compose up -d
```

---

## Configuration & ports

- **Frontend** runs on host port **4000**.
- **Backend** runs on host port **3000** (container also listens on 3000).
- **Keycloak** runs on host port **8080**.
- **MongoDB** runs on host port **27017** (internal DNS name: `mongodb:27017`).

If you change host ports, ensure:
- Frontend’s API base URL points to the backend host port (env `NEXT_PUBLIC_API_BASE_URL` if used).
- Keycloak client has matching **Redirect URIs** and **Web Origins** (e.g., `http://localhost:4000/*`).

---

## Troubleshooting

- **Pull error “no matching manifest for linux/amd64”**  
  Make sure you’re pulling the **multi-arch** tags (`:poc`). If you see this error, the tag you’re using wasn’t multi-arch.

- **Backend can’t connect to Mongo (e.g., `ECONNREFUSED`)**  
  Inside Compose, services resolve by **service name**, not `localhost`.  
  Connection string should look like:  
  `mongodb://root:example@mongodb:27017/<db>?authSource=admin`

- **CORS/auth redirects fail**  
  In Keycloak client settings, add:
  - Valid Redirect URIs: `http://localhost:4000/*`
  - Web Origins: `http://localhost:4000`

- **Re-import / reseed for a fresh demo**  
  Just `docker compose down && docker compose up -d`.

---

## Related projects & packages

This compose pulls prebuilt images from **GitHub Container Registry (GHCR)**:

- **Frontend image:** `ghcr.io/ikoko3/vre_maturity_frontend:poc`  
- **Backend image:** `ghcr.io/ikoko3/vre_maturity_backend:poc`  
- **Keycloak (preseed) image:** `ghcr.io/ikoko3/keycloak-preseed:poc`  
- **Mongo (preseed) image:** `ghcr.io/ikoko3/mongo-preseed:poc`

All packages under: https://github.com/ikoko3?tab=packages

**Compose repo:** https://github.com/ikoko3/VRE-Maturity-Management-Docker-Compose

> Source repositories for the frontend and backend are linked from their package pages.

---

## License & notes

- This stack is intended for **local testing/evaluation** (POC).  
- Do **not** use the shipped credentials or seeded data in production.  
- If you publish community builds, please remove demo users and secrets or override them via environment variables.

---

### Handy commands

```bash
# See logs
docker compose logs -f keycloak
docker compose logs -f mongodb
docker compose logs -f backend
docker compose logs -f frontend

# Recreate only one service
docker compose up -d --force-recreate backend

# Shell into a service
docker compose exec backend sh
docker compose exec mongodb mongosh -u root -p example --authenticationDatabase admin
```
