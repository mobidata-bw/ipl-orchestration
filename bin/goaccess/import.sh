#!/bin/sh

set -e
set -o pipefail

while true
do
  echo "importing Traefik access logs into GoAccess"
  # Note: With 0 matches, grep exits non-0 (which would break our while loop), so we run `true` in this case.
  # Traefik logs requests on all of its entrypoints, including the internal "admin" one, which in turn receives health check requests. We only want requests to the entrypoint for public consumption "web".
  # Note: Passing the `-` argument to goaccess is important, otherwise it won't import data from stdin in non-TTY environments. https://github.com/allinurl/goaccess/issues/945
  cat /var/log/traefik/access.log | (grep '"entryPointName":"web"' || true) \
    | goaccess --config-file=/etc/goaccess.conf --no-global-config -o /srv/goaccess/report/index.html --restore --persist -

  sleep 60
done
