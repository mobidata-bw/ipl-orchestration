# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),

## [Unreleased]

## Changes
* GBFS Feeds (general): With Lamassu [v2024-06-17T13-28](https://github.com/entur/lamassu/blob/master/Changelog.md), we now support GBFSv3. To request feeds in the new GBFSv3 version, instead of `sharing/gbfs` use `sharing/gbfs/v3/manifest.json`. With this version, accessing feeds which are not yet retreived from upstream will return an http status 502 (BAD GATEWAY) instead of 404 (NOT FOUND). 

### Fixes

* GBFS Feeds (Lime): for feeds of provider `Lime`, `station_status` and `station_information` feeds are from gbfs.json, as `Lime` associates all free floating bikes to a single station, which is semantically wrong (see [ipl-proxy v2024-06-19](https://github.com/mobidata-bw/ipl-proxy/blob/main/CHANGELOG.md).


## Tasks

* Several docker image updates:
  * Lamassu: Upgrade from v2024-04-29T06-37 to v2024-06-19T21-49
  * Geoserver: Upgrade from 2.24.3 to 2.25.2 (see [geoserver/releases](https://github.com/geoserver/geoserver/releases/))
  * Redis: Upgrade from v6 to v7
  * Caddy: Upgrade from v2.8.1-alpine to v2.8.4-alpine to 
  * RabbitMQ: Upgrade from v3.12 to v3.13
  * Redis: Upgrade from v6-alpine to v7-alpinw
  * Traefik: Upgrade from v2.11 to v3.0
  * Pipeline: Pin images versions to current version v2024-05-17t14-01


## [2024-06-18]

### Added

* ParkAPI: [Multiple new converters at ParkAPI Sources 0.5.0](https://github.com/ParkenDD/parkapi-sources-v3/blob/main/CHANGELOG.md#050)


### Fixes

* ⚠️ The `ipl-db` PostgreSQL database (server) doesn't bind on the host port `$IPL_POSTGRES_PORT` (default `5432`) anymore. – This change is intended to make it harder for adversaries to access the DB, particularly if IPL is deployed on a NAT-/firewall-less machine. You can still access the DB using the container port, whose IP address can be obtained using `docker inspect --format json "$(docker compose --env-file .env --env-file .env.local ps ipl-db --format '{{print .ID}}')" | jq -r '.[0].NetworkSettings.Networks | .[keys_unsorted[0]].IPAddress'`.
* ⚠️ The `pgbouncer` service doesn't bind on the host port `$PGBOUNCER_POSTGRES_PORT` (default `6432`) anymore. – Refer to the `ipl-db` change above for more details.
* Upgrade [x2gbfs](https://github.com/mobidata-bw/x2gbfs) to version `2024-06-10T16-07`. [Its changelog](https://github.com/mobidata-bw/x2gbfs/blob/ca00440f6c7ce26542cdd8c6b858755c2de51b75/CHANGELOG.md) documents the following changes:
  * add discovery uris for `stadtwerk_tauberfranken` (https://github.com/mobidata-bw/x2gbfs/commit/8f1f026e7f2132fae30de2c450965df0746bbbdd)
  * add additional pricing plans for cantamen-based providers ([#117](https://github.com/mobidata-bw/x2gbfs/pull/117))
  * fix: deer vehicles with missing extended properties are supported now, vehicles that can't be parsed from source will be ignored and a warning reported ([#116](https://github.com/mobidata-bw/x2gbfs/pull/116))
  * add deeplinks for MOQO-based providers, i.e. `stadtwerk_tauberfranken`
  * fix: remove plus and minus (`-`/`+`) chars from cantamen vehicle type ids to workaround lamassu id restriction
* ParkAPI: [Fixes calculating geo-distance at matching service](https://github.com/ParkenDD/park-api-v3/pull/162)
* ParkAPI: [Multiple fixes at ParkAPI Sources 0.5.0](https://github.com/ParkenDD/parkapi-sources-v3/blob/d606d8e9532ccb39bf855cfebe98e31f8486b26c/CHANGELOG.md#050)


## [2024-06-04]

### Features

* ParkAPI: Deletes ParkingSites if they don't exist in the latest pull / push
* ParkAPI: Several Improvements for Duplicate Matching Service:
  * Don't offer ParkingSites with different purposes as duplicates
  * Don't offer ParkingSites from the same source as duplicates as this is an data source issue
  * Add several fields at the duplicate JSON / CSV output
  * Add header line to duplicate CSVs
  * Give the ability to set the radius from client side
  * Improved output mechanisms
* New GBFS feed zeo_bruchsal (https://github.com/mobidata-bw/ipl-orchestration/pull/162)
* ParkAPI: Fixes at Bahn and Karlsruhe Converter


### Fixes

* ParkAPI: Add missing fields to OpenAPI documentation


## [2024-05-29]

### Fixes

* [Fixes ParkAPI issues at duplicate generation and downgrade migration](https://github.com/ParkenDD/park-api-v3/releases/tag/0.4.2)
* [Fixes ParkAPI lat/lon issue at XLSX uploads](https://github.com/ParkenDD/park-api-v3/releases/tag/0.4.3)


## [2024-05-21]

### Added

* [New ParkAPI sources](https://github.com/ParkenDD/parkapi-sources-v3/blob/0.4.0/CHANGELOG.md#040)
* [New experimental ParkAPI source RadVIS](https://github.com/ParkenDD/parkapi-sources-v3/blob/0.4.0/CHANGELOG.md#040)
* [Experimental ParkAPI duplicate matching](https://github.com/ParkenDD/park-api-v3/pull/144),
  additional information [at README](https://github.com/ParkenDD/park-api-v3?tab=readme-ov-file#flag-duplicates-via-command-line-interface)
* ParkAPI data model extension at `ParkingSite.type` (new enum values), `ParkingSite.tags` (generic tag system) and `ParkingSite.photo_url`
  (photos
* Addition of new bicycle parking style `mdbw_parking_sites_bicycle_types` in GeoServer based on `type` attribute after new bicycle parking layer `MobiData-BW:parking_sites_bicycle` was added
* Addition of `max_height` attribute to parking_sites layer

### Changed

* [Some converter fixes from ParkAPI sources project](https://github.com/ParkenDD/parkapi-sources-v3/blob/0.4.0/CHANGELOG.md#040)

### Removed

* bolt_winterthur GBFS feed


## [2024-05-08]

### Added

- Optional [cursor pagination at ParkAPI](https://github.com/ParkenDD/park-api-v3/pull/140)


## [2024-05-07]

### Added

- Added bike parking support in ParkAPI: https://github.com/ParkenDD/park-api-v3/pull/106 . Includes database migration
  and more fields in public API: https://api.mobidata-bw.de/park-api/documentation/public.html#/paths/v3-parking-sites/get
- [Normalizes radius search at ParkAPI](https://github.com/ParkenDD/park-api-v3/pull/133)
- Added new ParkAPI sources:
  - Barrierefreie Reisekette Baden-Württemberg: PKW-Parkplätze an Bahnhöfen
  - Barrierefreie Reisekette Baden-Württemberg: PKW-Parkplätze an Bushaltestellen
  - Barrierefreie Reisekette Baden-Württemberg: Fahrrad-Parkplätze an Bahnhöfen
  - Barrierefreie Reisekette Baden-Württemberg: Fahrrad-Parkplätze an Bushaltestellen
  - Stadt Neckarsulm: Fahrrad-Abstellanlagen
  - Kienzler
  - Stadt Mannheim
  - Stadt Buchen
  - Stadt Reutlingen: Fahrrad-Abstellanlagen
  - Baden-Württemberg: Parken und Mitfahren
- Geoserver: Added `parking_sites_bicycle` WMS/WFS layer

### Changed

- Fixed ParkAPI v1 endpoint to match old API specs: https://github.com/ParkenDD/park-api-v3/pull/127
- Changed to ParkAPI module approach: https://github.com/ParkenDD/park-api-v3/pull/106 . Published at
  https://pypi.org/project/parkapi-sources/
- Changed config file layout at ParkAPI, now all sources are defined in the same place. Example config:
  https://github.com/ParkenDD/park-api-v3/blob/75a87ffe6edd3eece57a4b73692f01b6695c74e0/config_dist_dev.yaml
- Fixes OpenAPI response schema at generic parking site endpoints
- Upgrade [Lamassu](https://github.com/entur/lamassu) to version 2024-04-29T06-37. This i.e. solves feed subscription issues on startup  (https://github.com/entur/lamassu/issues/442) and a metrics issue (see https://github.com/entur/lamassu/pull/439). ⚠️ Note: some metrics changed with this release, so monitoring/alerting configs might need to be updated.
- Upgrade [x2gbfs](https://github.com/mobidata-bw/x2gbfs) to version 2024-05-02t15-46. This i.e. solves lamassu's feed ingestion issues for `stadtmobil_karlsruhe` by removing currently unsupported characters from cantamen's vehicle type ids (see https://github.com/mobidata-bw/x2gbfs/pull/99 and https://github.com/mobidata-bw/x2gbfs/pull/103).
- Upgrade Geoserver to [version 2.24.3](https://geoserver.org/announcements/2024/04/18/geoserver-2-24-3-released.html) (includes [2.24.2 changes](https://geoserver.org/announcements/vulnerability/2024/01/24/geoserver-2-24-2-released.html)).
- Geoserver layer and style changes (https://github.com/mobidata-bw/ipl-orchestration/pull/146):
  - set defaultLocale to `de`
  - mapped SQL View bases feature's fid to primary key and made some geom types more specific

### Removed

-

## [2024-04-30]

### Added

- Add a CHANGELOG to document changes
- Add new GBFS feeds stadtmobil_karlsruhe (https://github.com/mobidata-bw/ipl-orchestration/pull/139) and nextbike_kk (https://github.com/mobidata-bw/ipl-orchestration/pull/140) (includes x2gbfs upgrade to 2024-04-30t05-08)

### Changed

- Changed gbfs feed update interval from 30s to 60s (60000ms) for prod, 6h for other machines. This can be configured via the new LAMASSU_FEED_UPATE_INTERVAL_IN_MS parameter, which defaults to 6h.
- Fix: For provider deer, inactive bookings are now ignored when calculating `is_reserved` status (https://github.com/mobidata-bw/x2gbfs/pull/95)
- Minor WMS styling changes (https://github.com/mobidata-bw/ipl-orchestration/pull/135)
