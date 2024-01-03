#!/bin/sh

set -e
set -o pipefail

tz="${TZ:?missing/empty \$TZ}"

# When this script is run by logrotate, it has to run on the just-rotated (old) log file, which *is not* called access.log (because the latter is already the new log file), so we provide a way to specify the file.
traefik_access_log_file="/var/log/traefik/${TRAEFIK_ACCESS_LOG_FILENAME:-access.log}"

# todo
# > Since piped data works based on a timestamp and there's no way to determine the inode nor the last line parsed, some issues could arise. For instance, a piped log could have multiple consecutive lines with the same timestamp (even at the second level), so it's likely to end up with duplicates entries. However, as a best practice and a reasonable assumption is that in most cases, for incremental log processing, users will parse data directly with goaccess instead of piping it through.

echo "importing Traefik access logs from $traefik_access_log_file into GoAccess"

# Note: With 0 matches, grep exits non-0 (which would break our while loop), so we run `true` in this case.
# Traefik logs requests on all of its entrypoints, including the internal "admin" one, which in turn receives health check requests. We only want requests to the entrypoint for public consumption "web".
# Note: Passing the `-` argument to goaccess is important, otherwise it won't import data from stdin in non-TTY environments. https://github.com/allinurl/goaccess/issues/945
cat "$traefik_access_log_file" | (grep '"entryPointName":"web"' || true) \
  | goaccess --config-file=/etc/goaccess.conf --no-global-config -o /srv/goaccess/report/index.html --restore --persist --tz="$tz" -
