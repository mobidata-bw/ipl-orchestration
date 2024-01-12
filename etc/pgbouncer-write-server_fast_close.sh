#!/bin/sh

set -e
set -u

# This is a temporary workaround until https://github.com/bitnami/containers/pull/54732 is merged & shipped.
server_fast_close="${PGBOUNCER_SERVER_FAST_CLOSE:-}"
if [ -n "$server_fast_close" ]; then
	# insert `server_fast_close=…` line after `pool_mode=session`
	# https://stackoverflow.com/a/15559399/1072129
	sed -i '/^pool_mode=session$/a server_fast_close=1' /opt/bitnami/pgbouncer/conf/pgbouncer.ini
fi
