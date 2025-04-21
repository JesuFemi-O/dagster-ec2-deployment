# Dagster Deployment Stack

This repo contains a modular, Docker-powered Dagster setup ready for local development and production deployment via GitHub Actions and Docker Hub.

---

## 📦 Project Structure

```
.
├── code-locations
│   ├── data-ingestion                     # Code location for ingestion assets
│   │   ├── definitions
│   │   │   ├── __init__.py
│   │   │   └── assets.py                  # Your Dagster assets (e.g. long_running_asset)
│   │   ├── Dockerfile                    # Buildable image for this code location
│   │   └── requirements.txt              # Python dependencies for this location
│   └── machine-learning                  # (placeholder for another location)
├── dagster-oss
│   ├── dagster.yaml                      # Dagster instance config (storage, launcher, etc.)
│   ├── Dockerfile                        # Multi-target build for webserver and daemon
│   └── workspace.yaml                    # Points to gRPC servers for code locations
├── docker-compose.yml                   # Spins up Dagster stack for local or remote runs
├── makefile                             # Handy targets for local dev workflows
└── README.md
```

---

## 🐳 Services

Each service in this stack is purpose-built and modular:

| Service             | Role                                                                 |
|---------------------|----------------------------------------------------------------------|
| `postgres`          | Stores run history, schedules, events, and asset metadata            |
| `ingestion_svc`     | gRPC code location (e.g. `data-ingestion`)                           |
| `dagster_webserver` | Hosts Dagit UI (Dagster webserver)                                   |
| `dagster_daemon`    | Runs background jobs: schedules, sensors, and run queue              |

**Source folders:**
- `code-locations/data-ingestion` → builds `ingestion_svc`
- `dagster-oss/Dockerfile` → multi-target build for `dagster_webserver` and `dagster_daemon`

---

## 💻 Local Development

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/)
- Python (only required for asset dev or local CLI work)
- Make (optional, included for convenience)

### Run the full stack

1. **Create your `.env` file** (see section below)
2. Launch everything with:

```bash
make up
```

Or manually:

```bash
docker compose up --build
```

---

## 🧪 Testing Asset Execution

A sample asset `long_running_asset` is available in the `data-ingestion` location. It simulates a 6-minute batch job by logging progress every 30 seconds.

You can materialize this asset via the Dagit UI at `http://localhost:3000` or by using the CLI:

```bash
dagster job launch --job-name ingest_everything
```

---

## 🛠️ GitHub CI/CD

### Code Location Workflow

This workflow:
- Builds and pushes the `ingestion_svc` image to Docker Hub
- Generates a `.env` file on the fly using secrets
- SSHes into EC2 and runs `docker compose pull` and `up` to restart the service

### Core Workflow

This workflow:
- Builds and pushes `dagster_webserver` and `dagster_daemon` images
- Deploys them via SSH

These workflows run only when relevant paths are updated in the `main` branch.

---

## 🧬 .env File

Your `.env` file should contain the following (automatically generated in GitHub Actions):

```
DAGSTER_POSTGRES_USER=postgres
DAGSTER_POSTGRES_PASSWORD=postgres
DAGSTER_POSTGRES_DB=dagster_poc
DAGSTER_CURRENT_IMAGE=jayefee/ingestion_svc:latest
```

---

## 🧩 Extras

- You can dynamically restart individual services using:
  ```bash
  docker compose up -d ingestion_svc
  docker compose up -d dagster_webserver dagster_daemon
  ```

- Assets are launched in **separate containers** to preserve stability during upgrades.
- GitHub Actions can be easily extended for more code locations and environments.

---

Happy hacking! ✨