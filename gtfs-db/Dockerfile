# todo: this base image is Prosperity-dual-licensed, obtain a purely Apache-licensed one
FROM ghcr.io/public-transport/gtfs-via-postgres:4.8.0-alpha.2 AS sql

WORKDIR /importer

ENV TERM=xterm-256color

# moreutils is needed for sponge
# ncurses is needed for tput
RUN apk update && apk add --no-cache \
	bash \
	moreutils \
	ncurses \
	unzip \
	wget

# configure the GTFS download
ARG GTFS_DOWNLOAD_USER_AGENT
ENV GTFS_DOWNLOAD_USER_AGENT=$GTFS_DOWNLOAD_USER_AGENT
ARG GTFS_DOWNLOAD_URL
ENV GTFS_DOWNLOAD_URL=$GTFS_DOWNLOAD_URL
ENV GTFS_TMP_DIR=/tmp/gtfs

ADD import.sh ./
RUN \
	--mount=type=cache,target=/tmp/gtfs,sharing=locked \
	env DEST_PATH=/tmp/sql/gtfs.sql \
		./import.sh

FROM postgis/postgis:15-3.4-alpine AS import

# configure access to the container-local PostgreSQL server
ARG POSTGRES_USER
ENV POSTGRES_USER=$POSTGRES_USER
ARG POSTGRES_PASSWORD
ENV POSTGRES_PASSWORD=$POSTGRES_PASSWORD
ARG POSTGRES_DB
ENV POSTGRES_DB=$POSTGRES_DB

# patch pre-populated docker-entrypoint.sh
# see https://github.com/docker-library/postgres/issues/731#issuecomment-1431638282
# see https://github.com/docker-library/postgres/blob/2f0ed0c7e8f8b05b294740f150397eec0af8dc50/15/alpine3.18/docker-entrypoint.sh
ADD docker-entrypoint.sh /usr/local/bin/
# tell docker-entrypoint.sh *not to* (re)start PostgreSQL after importing /docker-entrypoint-initdb.d/*
ENV POSTGRES_INIT_THEN_EXIT=1

# tune PostgreSQL: trade reliability for raw import performance
# https://stackoverflow.com/a/9407940
# todo: how? the following `docker-entrypoint.sh` flags didn't affect the import time:
# -c wal_level=logical \
# -c wal_log_hints=off \
# -c synchronous_commit=off \
# -c checkpoint_timeout=6h \
# -c full_page_writes=off \
# -c fsync=off \
# -c shared_buffers=2GB \
# -c work_mem=64MB \
# -c log_temp_files=1000000

# We prefix our GTFS SQL with `20_`, so that it gets processed *after* the pre-existing PostGIS init script (/docker-entrypoint-initdb.d/10_postgis.sh).
RUN \
	--mount=type=bind,from=sql,source=/tmp/sql,target=/tmp/sql \
	ln -s /tmp/sql/gtfs.sql /docker-entrypoint-initdb.d/20_gtfs.sql && \
	/usr/local/bin/docker-entrypoint.sh postgres && \
	rm /docker-entrypoint-initdb.d/20_gtfs.sql

# For the final image, use an "unadulterated" PostGIS image.
FROM postgis/postgis:15-3.4-alpine

LABEL org.opencontainers.image.title="GTFS importer, based on gtfs-via-postgres"
LABEL org.opencontainers.image.authors="MobiData-BW IPL contributors <mobidata-bw@nvbw.de>"

# Copy over the imported DB from the `import` stage.
COPY --from=import /var/lib/postgresql/data /var/lib/postgresql/data
