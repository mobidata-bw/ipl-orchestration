#!/usr/bin/env bash
# This is a modified version of ghcr.io/mobidata-bw/postgis-gtfs-importer:v4's download.sh [0]. It uses plain `curl` instead of curl-mirror because, with the latter, a peculiar bug occurs repeatedly [1]. I suspect curl-mirror to have a bug but haven't managed to reproduce it and isolate so far.
# [0] https://github.com/mobidata-bw/postgis-gtfs-importer/blob/76b148ec35bb63cb5821deb9e67bf12c0e0ad1c7/download.sh
# [1] https://github.com/mobidata-bw/postgis-gtfs-importer/issues/10

set -e
set -u
set -E # abort if subshells fail
set -o pipefail

source "$(dirname "$(realpath "$0")")/lib.sh"

ua="${GTFS_DOWNLOAD_USER_AGENT:?'missing/empty $GTFS_DOWNLOAD_USER_AGENT'}"
gtfs_url="${GTFS_DOWNLOAD_URL:?'missing/empty $GTFS_DOWNLOAD_URL'}"

verbose="${GTFS_DOWNLOAD_VERBOSE:-true}"
if [ "$verbose" != false ]; then
	set -x # enable xtrace
fi

print_bold "Downloading the GTFS feed from $GTFS_DOWNLOAD_URL."

mkdir -p "$gtfs_tmp_dir"

# The following section is modified to (try to) work around https://github.com/mobidata-bw/postgis-gtfs-importer/issues/10.
# To emulate atomic behaviour, first download to `$zip_path.download`, then rename to `$zip_path`.
rm -f "$zip_path.download" "$zip_path"
curl \
	-fsSL \
	--compressed \
	-H "User-Agent: $ua" \
	-o "$zip_path.download" \
	"$gtfs_url"
mv "$zip_path.download" "$zip_path"
