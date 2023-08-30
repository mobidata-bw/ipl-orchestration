DOCKER_COMPOSE = docker compose --env-file .env --env-file .env.local

DOCKER_REGISTRY = registry.git.sectio-aurea.org

# Default target when running `make`
.PHONY: all
all: docker-up


# Container management
# --------------------

# Login to Docker registry
.PHONY: docker-login
docker-login:
	docker login $(DOCKER_REGISTRY)

# Builds and starts all docker containers. Also works for restarting without downtime. Supports starting or restarting
# by SERVICE (e.g. `make docker-up SERVICE=redis`)
.PHONY: docker-up
docker-up:
	$(DOCKER_COMPOSE) up $(SERVICE)

# Start containers in background (or recreate containers while they are running attached to another terminal)
.PHONY: docker-up-detached
docker-up-detached:
	$(DOCKER_COMPOSE) up --detach

.PHONY: docker-down
docker-down:
	$(DOCKER_COMPOSE) down --remove-orphans

# Restart all containers (default) or only the containers specified by SERVICE (e.g. `make docker-restart SERVICE=redis`)
.PHONY: docker-restart
docker-restart: .env
	$(DOCKER_COMPOSE) restart $(SERVICE)

# Tear down all containers and delete all volumes
.PHONY: docker-purge
docker-purge: .env
	$(DOCKER_COMPOSE) down --remove-orphans --volumes
