#!/usr/bin/env bash
# /begin mod
# This Script is mostly a copy of https://github.com/geosolutions-it/docker-geoserver/blob/master/geoserver-rest-config.sh
# It adds optional copying of a GEOSERVER_DATA_DIR_CUSTOM/* to GEOSERVER_DATA_DIR before startup
set -eo pipefail
# /end mod
while [ "$(curl -s --retry-connrefused --retry 100 -I http://localhost:8080/geoserver/web/ 2>&1 |grep 200)" == "" ];do
  echo "Waiting for GeoServer to be Up and running"
done  
if [ "$ADMIN_PASSWORD" != "" ]; then
    echo "GeoServer password is likely to be default, going to change to new admin password."
    ADMIN_HEADER=$(echo -n "admin:geoserver" | base64)
    curl -H "Authorization: basic $ADMIN_HEADER" -X PUT http://localhost:8080/geoserver/rest/security/self/password -H  "accept: application/json" -H  "content-type: application/json" -d "{  \"newPassword\": \"$ADMIN_PASSWORD\"}"  
fi
# /begin mod
if [ "$GEOSERVER_DATA_DIR_CUSTOM" != "" ]; then
  # Sleep 5 seconds as admin password reset apparently is not completed when call to rest/security/self/password returns. 
  # when reloading config immediatly without sleep, we receive a 403 response...
  sleep 5
  /usr/local/bin/geoserver-rest-reload.sh
fi
# /end mod 