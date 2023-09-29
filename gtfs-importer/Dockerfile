FROM node:20-bookworm-slim
LABEL org.opencontainers.image.title="GTFS importer, using gtfstidy & gtfs-via-postgres to import GTFS data into PostgreSQL."
LABEL org.opencontainers.image.authors="MobiData-BW IPL contributors <mobidata-bw@nvbw.de>"

WORKDIR /importer

ENV TERM=xterm-256color

# https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

# curl is needed to download the GTFS
# moreutils is needed for sponge
# postgresql-client is needed for psql
RUN apt update && apt install -y \
	bash \
	curl \
	moreutils \
	postgresql-client \
	unzip \
	zstd \
	&& rm -rf /var/lib/apt/lists/*

RUN \
	curl -fsSL \
	-H 'User-Agent: gtfs-importer (github.com/mobidata-bw/ipl-orchestration)' \
	-o /usr/local/bin/gtfstidy \
	"https://github.com/patrickbr/gtfstidy/releases/download/v0.2/gtfstidy.v0.2.$TARGETOS.$TARGETARCH" \
	&& chmod +x /usr/local/bin/gtfstidy

# todo: gtfs-via-postgres is Prosperity-dual-licensed, obtain a purely Apache-licensed version
RUN npm install -g gtfs-via-postgres@4

ADD package.json ./
RUN npm install --omit dev && npm cache clean --force

ADD . .

ENTRYPOINT []
CMD ["/usr/local/bin/node", "importer.js"]
