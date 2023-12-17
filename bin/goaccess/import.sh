#!/bin/sh

set -e
set -o pipefail

tz="${TZ:?missing/empty \$TZ}"

# todo
# > Since piped data works based on a timestamp and there's no way to determine the inode nor the last line parsed, some issues could arise. For instance, a piped log could have multiple consecutive lines with the same timestamp (even at the second level), so it's likely to end up with duplicates entries. However, as a best practice and a reasonable assumption is that in most cases, for incremental log processing, users will parse data directly with goaccess instead of piping it through.

while true
do
  echo "importing Traefik access logs into GoAccess"
  # Note: With 0 matches, grep exits non-0 (which would break our while loop), so we run `true` in this case.
  # Traefik logs requests on all of its entrypoints, including the internal "admin" one, which in turn receives health check requests. We only want requests to the entrypoint for public consumption "web".
  # Note: Passing the `-` argument to goaccess is important, otherwise it won't import data from stdin in non-TTY environments. https://github.com/allinurl/goaccess/issues/945
  cat /var/log/traefik/access.log | (grep '"entryPointName":"web"' || true) \
    | goaccess --config-file=/etc/goaccess.conf --no-global-config -o /srv/goaccess/report/index.html --restore --persist --tz="$tz" -

  # todo: rotate Traefik log file, send SIGUSR1 so that it reopens it?
  # traefik_container="${TRAEFIK_CONTAINER:-'traefik'}"
  # docker kill --signal="USR1" "$traefik_container"

  sleep 60
done
