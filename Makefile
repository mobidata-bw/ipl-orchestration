DOCKER_COMPOSE = docker compose --env-file .env --env-file .env.local

DOCKER_REGISTRY = ghcr.io

# Assign PWD explicitly, as PWD is user home when called via ansible make module
PWD :=  $(abspath $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST))))))

# Read environment variable files, in case they exist
-include .env .env.local

# Default target when running `make`
.PHONY: all
all: docker-up

# SFTP server config
etc/sftp/users.conf:
	mkdir -p etc/sftp
	touch etc/sftp/users.conf
etc/sftp/ssh_host_ed25519_key:
	mkdir -p etc/sftp
	ssh-keygen -f etc/sftp/ssh_host_ed25519_key -t ed25519 -N '' -C 'MobiData BW SFTP server' -q
etc/sftp/ssh_host_rsa_key:
	mkdir -p etc/sftp
	ssh-keygen -f etc/sftp/ssh_host_rsa_key -t rsa -b 4096 -N '' -C 'MobiData BW SFTP server' -q

.PHONY: init
init: etc/sftp/users.conf etc/sftp/ssh_host_ed25519_key etc/sftp/ssh_host_rsa_key
	mkdir -p var/gtfs
	touch -a var/gtfs/pgbouncer-dsn.txt
	mkdir -p var/geoserver/datadir
	touch -a var/geoserver/datadir/global.xml
	mkdir -p var/geoserver/gwc_cache_dir
	mkdir -p var/geoserver/logs
	mkdir -p var/goaccess/data
	mkdir -p var/goaccess/report
	mkdir -p var/ocpdb/logs
	mkdir -p var/ocpdb/temp
	mkdir -p var/park-api/logs
	mkdir -p var/park-api/temp
	mkdir -p var/traffic

# Container management
# --------------------

# Login to Docker registry
.PHONY: docker-login
docker-login:
	docker login $(DOCKER_REGISTRY)

# Builds and starts all docker containers. Supports starting by SERVICE (e.g. `make docker-up SERVICE=redis`)
.PHONY: docker-up
docker-up: init
	$(DOCKER_COMPOSE) up --wait-timeout 120 $(SERVICE)

# Start containers in background (or recreate containers while they are running attached to another terminal). Supports starting or
# restarting by SERVICE (e.g. `make docker-up-detached SERVICE=redis`)
.PHONY: docker-up-detached
docker-up-detached: init
	$(DOCKER_COMPOSE) up --detach --wait --wait-timeout 120 $(SERVICE)
	# Reload geoserver config. Might fail with service "geoserver" 
	# is not running if geoserver has not yet been started. This can be ignored
	$(DOCKER_COMPOSE) exec geoserver /usr/local/bin/geoserver-rest-reload.sh || true

.PHONY: docker-down
docker-down:
	$(DOCKER_COMPOSE) down --remove-orphans --timeout 60 $(SERVICE)
.PHONY: docker-kill
docker-kill:
	$(DOCKER_COMPOSE) kill --remove-orphans $(SERVICE)

# Restart all containers (default) or only the containers specified by SERVICE (e.g. `make docker-restart SERVICE=redis`)
.PHONY: docker-restart
docker-restart: init
	$(DOCKER_COMPOSE) restart $(SERVICE)

# Pull all images or only the containers specified by SERVICE (e.g. `make docker-pull SERVICE=redis`)
.PHONY: docker-pull
docker-pull:
	docker pull ${IPL_GTFS_IMPORTER_IMAGE}
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

# Lists all docker containers. Supports filtering by SERVICE (e.g. `make docker-ps SERVICE=lamassu`).
.PHONY: docker-ps
docker-ps:
	$(DOCKER_COMPOSE) ps $(SERVICE)

# Geoserver management
# --------------------

.PHONY: reload-geoserver
reload-geoserver:
	$(DOCKER_COMPOSE) exec geoserver /usr/local/bin/geoserver-rest-reload.sh

# GTFS data management
# --------------------

.PHONY: import-new-gtfs
import-new-gtfs: init
	$(DOCKER_COMPOSE) build gtfs-importer
	$(DOCKER_COMPOSE) --profile import-new-gtfs run --rm gtfs-importer
	# make sure pgbouncer is running
	$(DOCKER_COMPOSE) --profile import-new-gtfs up --detach --wait --wait-timeout 30 pgbouncer
	$(DOCKER_COMPOSE) --profile import-new-gtfs exec pgbouncer /reload-pgbouncer-databases.sh

.PHONY: gtfs-db-psql
gtfs-db-psql:
	$(DOCKER_COMPOSE) exec -e PGDATABASE gtfs-db /bin/sh -c 'export PGUSER="$$POSTGRES_USER" PGPASSWORD="$$POSTGRES_PASSWORD"; env PGDATABASE="$$(psql gtfs_importer -b -t --csv -c "SELECT db_name FROM latest_import" | xargs)" psql'

.PHONY: gtfs-db-latest-import
gtfs-db-latest-import:
	$(DOCKER_COMPOSE) exec gtfs-db /bin/sh -c 'env PGUSER="$$POSTGRES_USER" PGPASSWORD="$$POSTGRES_PASSWORD" PGDATABASE=gtfs_importer psql -b -t --csv -c "SELECT db_name FROM latest_import"'



# OCPDB management
# ------------------

.PHONY: ocpdb-upgrade
ocpdb-upgrade:
	$(DOCKER_COMPOSE) exec ocpdb-flask /bin/sh -c 'flask db upgrade'

.PHONY: ocpdb-shell
ocpdb-shell:
	$(DOCKER_COMPOSE) exec ocpdb-flask /bin/sh


# ParkAPI management
# ------------------

.PHONY: park-api-upgrade
park-api-upgrade:
	$(DOCKER_COMPOSE) exec park-flask /bin/sh -c 'flask db upgrade'

.PHONY: park-api-shell
park-api-shell:
	$(DOCKER_COMPOSE) exec park-api-flask /bin/bash

