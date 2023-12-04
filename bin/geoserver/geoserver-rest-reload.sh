#!/usr/bin/env bash

# /begin mod
# This Script is mostly a copy of https://github.com/geosolutions-it/docker-geoserver/blob/master/geoserver-rest-reload.sh
# It differs in it's set options, i.e. disable trace output, enable failing: 
set -eo pipefail
#set -x
# /end mod
#while [ "$(curl -s --retry-connrefused --retry 100 -I http://localhost:8080/geoserver/web/ 2>&1 |grep 200)" == "" ];do
#  echo "Waiting for GeoServer to be Up and running"
#done  
if [ "$ADMIN_PASSWORD" != "" ]; then
    ADMIN_HEADER=$(echo -n "admin:${ADMIN_PASSWORD}" | base64)    
else
    ADMIN_HEADER=$(echo -n "admin:geoserver"| base64)
fi 

curl -H "Authorization: basic ${ADMIN_HEADER}" -X POST http://localhost:8080/geoserver/rest/reload -H  "accept: application/json" -H  "content-type: application/json"
