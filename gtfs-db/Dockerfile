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

ADD import.sh ./
RUN \
	--mount=type=cache,target=/tmp/gtfs,sharing=locked \
	env \
		GTFS_TMP_DIR=/tmp/gtfs \
		DEST_PATH=/tmp/sql/gtfs.sql \
		./import.sh

FROM postgis/postgis:15-3.4-alpine AS import

# configure access to the container-local PostgreSQL server
ARG POSTGRES_USER
ENV POSTGRES_USER=$POSTGRES_USER
ARG POSTGRES_PASSWORD
ENV POSTGRES_PASSWORD=$POSTGRES_PASSWORD
ARG POSTGRES_DB
ENV POSTGRES_DB=$POSTGRES_DB

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
