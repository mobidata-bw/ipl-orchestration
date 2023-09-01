#!/bin/bash
set -e
set -o pipefail
set -x

docker compose run gtfs-importer
docker compose restart --timeout 30 gtfs-api
