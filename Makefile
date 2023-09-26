DOCKER_COMPOSE = docker compose --env-file .env --env-file .env.local

DOCKER_REGISTRY = ghcr.io

GEOSERVER_ENV_FILE = etc/geoserver/geoserver-environment.properties

# Default target when running `make`
.PHONY: all
all: docker-up


# Container management
# --------------------

# Login to Docker registry
.PHONY: docker-login
docker-login:
	docker login $(DOCKER_REGISTRY)

# Builds and starts all docker containers. Supports starting by SERVICE (e.g. `make docker-up SERVICE=redis`)
.PHONY: docker-up
docker-up:
	$(DOCKER_COMPOSE) up $(SERVICE)

# Start containers in background (or recreate containers while they are running attached to another terminal). Supports starting or
# restarting by SERVICE (e.g. `make docker-up-detached SERVICE=redis`)
.PHONY: docker-up-detached
docker-up-detached:
	$(DOCKER_COMPOSE) up --detach $(SERVICE)

.PHONY: docker-down
docker-down:
	$(DOCKER_COMPOSE) down --remove-orphans $(SERVICE)

# Restart all containers (default) or only the containers specified by SERVICE (e.g. `make docker-restart SERVICE=redis`)
.PHONY: docker-restart
docker-restart:
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

# Geoserver management
# --------------------

# The Geoserver cannot pick up configuration data from environment variables,
# so in order to make it configurable using `.env` and `.env.local`, we generate
# a file `$GEOSERVER_ENV_FILE` using `docker compose config`. Essentially, we're
# "flattening" `geoserver`'s entire env var configuration.
# The generated config file is then read by `geoserver` on startup. Only variables
# referenced within `geoserver`'s other config files get used, the others ignored.
# see also https://docs.geoserver.org/stable/en/user/datadirectory/configtemplate.html
.PHONY: geoserver-config
geoserver-config:
	$(DOCKER_COMPOSE) config --format json geoserver \
		| jq -rc '.services.geoserver.environment | to_entries[] | .key + "=" + .value' \
		>"$(GEOSERVER_ENV_FILE)"

# GTFS data management
# --------------------

.PHONY: import-new-gtfs-only
import-new-gtfs-only:
	$(DOCKER_COMPOSE) build gtfs-importer
	$(DOCKER_COMPOSE) --profile import-new-gtfs run --rm gtfs-importer

.PHONY: import-new-gtfs
import-new-gtfs: import-new-gtfs-only | geoserver-config
	$(DOCKER_COMPOSE) restart --timeout 30 gtfs-api
	$(DOCKER_COMPOSE) restart --timeout 60 geoserver
