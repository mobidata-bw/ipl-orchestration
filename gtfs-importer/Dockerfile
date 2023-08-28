# todo: this base image is Prosperity-dual-licensed, obtain a purely Apache-licensed one
FROM ghcr.io/public-transport/gtfs-via-postgres:4
LABEL org.opencontainers.image.title="GTFS importer, based on gtfs-via-postgres"
LABEL org.opencontainers.image.authors="MobiData-BW IPL contributors <mobidata-bw@nvbw.de>"

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

ADD . .

ENTRYPOINT ["/bin/bash"]
CMD ["import.sh"]
