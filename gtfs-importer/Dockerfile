FROM node:20-bookworm-slim
LABEL org.opencontainers.image.title="GTFS importer, using gtfs-via-postgres to import GTFS data into PostgreSQL."
LABEL org.opencontainers.image.authors="MobiData-BW IPL contributors <mobidata-bw@nvbw.de>"

WORKDIR /importer

ENV TERM=xterm-256color

# moreutils is needed for sponge
# postgresql-client is needed for psql
RUN apt update && apt install -y \
	bash \
	moreutils \
	postgresql-client \
	unzip \
	wget \
	zstd \
	&& rm -rf /var/lib/apt/lists/*

# todo: gtfs-via-postgres is Prosperity-dual-licensed, obtain a purely Apache-licensed version
RUN npm install -g gtfs-via-postgres@4

ADD package.json ./
RUN npm install --omit dev && npm cache clean --force

ADD . .

ENTRYPOINT []
CMD ["/usr/local/bin/node", "importer.js"]
