# Dagster Deployment Stack

This repo contains a modular, Docker-powered Dagster setup ready for local development and production deployment via GitHub Actions and Docker Hub.

📦 Project Structure

.
├── code-locations
│   ├── data-ingestion              # Code location for ingestion assets
│   │   ├── definitions
│   │   │   ├── __init__.py
│   │   │   └── assets.py           # Your Dagster assets (e.g. long_running_asset)
│   │   ├── Dockerfile              # Buildable image for this code location
│   │   └── requirements.txt        # Python dependencies for this location
│   └── machine-learning            # (placeholder for another location)
├── dagster-oss
│   ├── dagster.yaml                # Dagster instance config (storage, launcher, etc.)
│   ├── Dockerfile                  # Multi-target build for webserver and daemon
│   └── workspace.yaml              # Points to gRPC servers for code locations
├── docker-compose.yml             # Spins up Dagster stack for local or remote runs
├── makefile                        # Handy targets for local dev workflows
└── README.md

🐳 Services

Service	Role	Built From
postgres	Stores run history, schedules, events	Official image
ingestion_svc	gRPC code location (data-ingestion)	Dockerfile
dagster_webserver	UI + Dagit	dagster-oss
dagster_daemon	Scheduler, sensors, run coordinator	dagster-oss

💻 Local Development

Prerequisites
	•	Docker
	•	Docker Compose
	•	Python (for asset dev if needed)
	•	Make (optional, but included)

Run the full stack

# Ensure you have your .env file
cp .env.example .env  # if needed

# Start Dagster and dependencies
docker compose up -d

Useful Targets

make build-core         # Build dagster_webserver and dagster_daemon images
make build-ingestion    # Build code location image
make push-ingestion     # Push to Docker Hub

🚀 CI/CD Deployment

This repo uses GitHub Actions to:
	•	Auto-build and push Docker images to Docker Hub
	•	SSH into an EC2 instance and deploy updated containers
	•	Auto-generate .env on the fly with GitHub secrets

CI/CD Triggers

Workflow	Triggered When…
code-location-deploy.yml	Code changes in data-ingestion
core-deploy.yml	Changes in dagster-oss (web + daemon)

Secrets Required in GitHub

Secret Name	Description
DOCKER_USERNAME	Docker Hub username
DOCKER_PASSWORD	Docker Hub password or PAT
DEPLOY_KEY	SSH private key for EC2 access
EC2_HOST	IP/hostname of EC2 instance
EC2_USER	e.g., ec2-user or ubuntu
DB_USER	Postgres username
DB_PASSWORD	Postgres password
DB_NAME	Postgres DB name

🧠 Gotchas & Learnings
	•	DagsterRunLauncher containers must be on the same Docker network (dagster-poc-network)
	•	All runs happen in isolated containers — code changes don’t affect in-flight runs
	•	Use print() carefully — to view logs, check the stdout tab in Dagit
	•	Docker images must be built for linux/amd64 to work properly on EC2

✅ Coming Soon
	•	Terraform provisioning for EC2, networking, and RDS
	•	Support for additional code locations (machine-learning)
	•	More advanced asset orchestration with dbt, sensors, schedules
