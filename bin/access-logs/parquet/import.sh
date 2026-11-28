#!/bin/sh

set -euo pipefail

scripts_dir="$(dirname "$0")"
tz="${TZ:?missing/empty \$TZ}"

# When this script is run by logrotate, it has to run on the just-rotated (old) log file, which *is not* called access.log (because the latter is already the new log file), so we provide a way to specify the file.
access_log_file="/var/log/traefik/${TRAEFIK_ACCESS_LOG_FILENAME:-access.log}"
parquet_filename="$access_log_file.parquet" \

set -x


env \
  TRAEFIK_ACCESS_LOG_FILENAME="$access_log_file" \
  PARQUET_FILENAME="$parquet_filename" \
  duckdb \
  -f "$scripts_dir/import-logs-into-parquet.sql" \

# todo: delete old logs to prevent disk space from filling up?
