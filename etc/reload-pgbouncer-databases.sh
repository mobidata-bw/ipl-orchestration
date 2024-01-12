#!/bin/bash

set -eu -o pipefail

export PGUSER="$POSTGRESQL_USERNAME"
export PGPASSWORD="$POSTGRESQL_PASSWORD"

set -x

# this script gets called at pgbouncer's startup as well
/opt/bitnami/scripts/pgbouncer/setup.sh

# https://www.pgbouncer.org/usage.html
# > SUSPEND
# > All socket buffers are flushed and PgBouncer stops listening for data on them. The command will not return before all buffers are empty. To be used at the time of PgBouncer online reboot.
# > New client connections to a suspended database will wait until RESUME is called.
# > RELOAD
# > The PgBouncer process will reload its configuration files and update changeable settings. This includes the main configuration file as well as the files specified by the settings auth_file and auth_hba_file.
# > PgBouncer notices when a configuration file reload changes the connection parameters of a database definition. An existing server connection to the old destination will be closed when the server connection is next released (according to the pooling mode), and new server connections will immediately use the updated connection parameters.
# > RESUME [db]
# > Resume work from previous KILL, PAUSE, or SUSPEND command.
psql -b -v 'ON_ERROR_STOP=1' -p 6432 pgbouncer <<EOF
SUSPEND;
RELOAD;
RESUME;
EOF
