DOCKER_COMPOSE = docker compose --env-file .env --env-file .env.local

DOCKER_REGISTRY = ghcr.io

# Default target when running `make`
.PHONY: all
all: docker-up

.PHONY: init
init:
	touch -a .imported-gtfs-db.env

# Container management
# --------------------

# Login to Docker registry
.PHONY: docker-login
docker-login:
	docker login $(DOCKER_REGISTRY)

# Builds and starts all docker containers. Supports starting by SERVICE (e.g. `make docker-up SERVICE=redis`)
.PHONY: docker-up
docker-up: init
	$(DOCKER_COMPOSE) up $(SERVICE)

# Start containers in background (or recreate containers while they are running attached to another terminal). Supports starting or
# restarting by SERVICE (e.g. `make docker-up-detached SERVICE=redis`)
.PHONY: docker-up-detached
docker-up-detached: init
	$(DOCKER_COMPOSE) up --detach $(SERVICE)

.PHONY: docker-down
docker-down:
	$(DOCKER_COMPOSE) down --remove-orphans $(SERVICE)

# Restart all containers (default) or only the containers specified by SERVICE (e.g. `make docker-restart SERVICE=redis`)
.PHONY: docker-restart
docker-restart: init
	$(DOCKER_COMPOSE) restart $(SERVICE)

# Pull all images or only the containers specified by SERVICE (e.g. `make docker-pull SERVICE=redis`)
.PHONY: docker-pull
docker-pull:
	$(DOCKER_COMPOSE) pull $(SERVICE)

# Tear down all containers and delete all volumes
.PHONY: docker-purge
docker-purge:
	$(DOCKER_COMPOSE) down --remove-orphans --volumes

# Prints the entire Compose config, with environment variables filled in.
# Optionally, a SERVICE can be specified to restrict the config.
.PHONY: docker-config
docker-config:
	$(DOCKER_COMPOSE) config $(SERVICE)

# GTFS data management
# --------------------

.PHONY: import-new-gtfs
import-new-gtfs: init
	$(DOCKER_COMPOSE) build gtfs-importer
	$(DOCKER_COMPOSE) --profile import-new-gtfs run --rm gtfs-importer
	# restart dependent services
	# Restarting the containers would re-run them with the old env vars, so we `stop` & `start` instead.
	$(DOCKER_COMPOSE) stop --timeout 30 gtfs-api geoserver
	$(DOCKER_COMPOSE) rm gtfs-api geoserver
	$(DOCKER_COMPOSE) up -d --wait --wait-timeout 30 gtfs-api geoserver
