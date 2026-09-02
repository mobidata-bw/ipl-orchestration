#!/bin/bash

set -euxo pipefail

# todo: from startup.sh:
# envsubst < "${CONFIG_OVERRIDES_DIR}"/"${CONFIG_FILE}" > "${CATALINA_HOME}/conf/${CONFIG_FILE}"

# todo: look into `/opt/handle_geoserver_admin_credentials.sh`

	# todo: doesn't work yet
	# todo: use `$RUN_WITH_USER_UID`/`$RUN_WITH_USER_GID`?
	# --user '999:999' -e RUN_UNPRIVILEGED=true -e CHANGE_OWNERSHIP_ON_FOLDERS='/usr/local/tomcat /opt/geoserver_data' \
	# - `$CATALINA_HOME/conf/healthcheck_url.txt` needs write permission
	# - `$CATALINA_HOME/webapps/geoserver/WEB-INF/lib/` *may* need write permission
	# - `${CATALINA_HOME}/webapps/geoserver/WEB-INF/web.xml` *may* need write permission

# todo: set proper admin user/pw

docker run --rm -it --name geoserver-3 \
	-v ./etc/geoserver:/opt/geoserver_data \
	-v ./var/geoserver/datadir:/opt/geoserver_data/datadir \
	-v ./etc/geoserver/global.xml:/opt/geoserver_data/global.xml \
	-v ./etc/geoserver/logging.xml:/opt/geoserver_data/logging.xml \
	-e EXTRA_JAVA_OPTS='-Xms512M -Xmx4G' \
	-e GEOSERVER_ADMIN_USER=admin -e GEOSERVER_ADMIN_PASSWORD=admin \
	-p 8600:8080 \
	ghcr.io/mobidata-bw/ipl-geoserver:2.28.5-local
