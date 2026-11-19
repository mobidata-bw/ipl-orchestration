# Note: We use Debian Slim because DuckDB currently requires libc but Alpine Linux uses musl.
FROM debian:13-slim AS builder

# install DuckDB
RUN \
	--mount=type=cache,target=/var/cache/apt,sharing=locked \
	--mount=type=cache,target=/var/lib/apt,sharing=locked \
	apt update && apt-get --no-install-recommends install -y \
	curl ca-certificates
# renovate: datasource=github-releases depName=duckdb/duckdb versioning=semver
ARG DUCKDB_VERSION=2.0.0
ENV DUCKDB_VERSION=$DUCKDB_VERSION
RUN \
	curl 'https://install.duckdb.org' -fsSL | bash \
	&& cp /root/.duckdb/cli/$DUCKDB_VERSION/duckdb /usr/local/bin/duckdb

FROM debian:13-slim

COPY \
	--from=builder \
	/usr/local/bin/duckdb /usr/local/bin/duckdb

CMD ["/usr/local/bin/duckdb"]
