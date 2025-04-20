PROJECT ?= dagster-prod
IMAGE_NS ?= yourdockerhubuser
INGESTION_IMAGE ?= $(IMAGE_NS)/ingestion_svc:latest
WEB_IMAGE ?= $(IMAGE_NS)/dagster_webserver:latest
DAEMON_IMAGE ?= $(IMAGE_NS)/dagster_daemon:latest

# Local dev
up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

# Build images
build-ingestion:
	docker build -t $(INGESTION_IMAGE) ./code-locations/data-ingestion

build-web:
	docker build -t $(WEB_IMAGE) ./dagster-oss

build-daemon:
	docker build -t $(DAEMON_IMAGE) ./dagster-oss

# Push images
push-ingestion:
	docker push $(INGESTION_IMAGE)

push-web:
	docker push $(WEB_IMAGE)

push-daemon:
	docker push $(DAEMON_IMAGE)

# Deploy restart
restart-ingestion:
	ssh -i demo-sandbox-kp.pem ec2-user@$(EC2_HOST) "docker pull $(INGESTION_IMAGE) && docker restart ingestion_svc"