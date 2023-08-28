#!/usr/bin/env bash
set -e
set -E # abort if subshells fail
set -o pipefail

print_bold () {
	if [ -t 0 ]; then
		echo "$(tput bold)$1$(tput sgr0)"
	else
		echo "$1"
	fi
}

ua="${GTFS_DOWNLOAD_USER_AGENT:-IPL (MobiData-BW)}"
bwgesamt='https://www.nvbw.de/fileadmin/user_upload/service/open_data/fahrplandaten_mit_liniennetz/bwgesamt.zip'
gtfs_url="${GTFS_DOWNLOAD_URL:-$bwgesamt}"
gtfs_tmp_dir="${GTFS_TMP_DIR:-/tmp/gtfs}"
mkdir -p "$gtfs_tmp_dir"

zip_path="$gtfs_tmp_dir/gtfs.zip"
extracted_path="$gtfs_tmp_dir/gtfs"

print_bold "Downloading & extracting the GTFS feed from $GTFS_DOWNLOAD_URL."
set -x

# Using wget's -c & -N is not an option here, see https://gist.github.com/derhuerst/745cf09fe5f3ea2569948dd215bbfe1a
# todo: use a (more?) correct & efficient mirroring script
wget -nv -U "$ua" -O "$zip_path" "$gtfs_url"
rm -rf "$extracted_path"
unzip -d "$extracted_path" "$zip_path"

set +x
print_bold "Importing GTFS feed into the $PGDATABASE database."
set -x

# todo: create new db, import into it, switch to it, delete old – safely despite crashes!

gtfs-via-postgres -d \
	--trips-without-shape-id --lower-case-lang-codes \
	--stops-location-index \
	--import-metadata \
	--schema api --postgrest \
	"$extracted_path/"*.txt \
	| sponge \
	| psql -b

set +x
print_bold 'Done!'

cat <<EOF
Run PostgREST with the following environment variables:'
PGRST_DB_SCHEMAS=api
PGRST_DB_ANON_ROLE=web_anon
EOF
