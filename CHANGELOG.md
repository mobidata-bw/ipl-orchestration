# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),

[Unreleased]

### Changes

- ParkAPI 0.10.0 with [Parking Site Groups](https://github.com/ParkenDD/park-api-v3/blob/9a02a9694bcda107bb5a8dd2100591b8ddc3b7d3/CHANGELOG.md#0100)
- ⚠️ ParkAPI 0.10.0 with [Kienzler SplitUp](https://github.com/ParkenDD/park-api-v3/blob/9a02a9694bcda107bb5a8dd2100591b8ddc3b7d3/CHANGELOG.md#0100).
  If you used the `kienzler` converter before, please make sure that you update your config.

### Fixes

- ParkAPI 0.10.0 with [Karlsruhe Converter Fix](https://github.com/ParkenDD/park-api-v3/blob/9a02a9694bcda107bb5a8dd2100591b8ddc3b7d3/CHANGELOG.md#0100)
- ParkAPI 0.10.0 with [SQL Query optimizations for faster responses](https://github.com/ParkenDD/park-api-v3/blob/9a02a9694bcda107bb5a8dd2100591b8ddc3b7d3/CHANGELOG.md#0100)


## 2024-08-13

### Added

- ParkAPI 0.9.0 with [Swiss OpenData](https://github.com/ParkenDD/park-api-v3/blob/ff4d20ed47ebcdc1cc9bf5c9ea7fbf48218cba68/CHANGELOG.md#090)


### Changes

- `gtfs-api`: Upgrade PostgREST from 12.2.2 to [12.2.3](https://github.com/PostgREST/postgrest/releases/tag/v12.2.3)
- ParkAPI 0.9.0 with [Fixes for Ellwangen, Karlsruhe, Goldbeck, Ulm, Herrenberg, BFRK](https://github.com/ParkenDD/park-api-v3/blob/ff4d20ed47ebcdc1cc9bf5c9ea7fbf48218cba68/CHANGELOG.md#090):


## 2024-07-31

### Changes

- Geoserver: Upgrade from 2.25.2 to 2.25.3 (see [geoserver/releases](https://github.com/geoserver/geoserver/releases/))

## 2024-07-23

### Changes

- ParkAPI 0.8.0 with [better logging](https://github.com/ParkenDD/park-api-v3/pull/178) ,
  [Goldbeck converter](https://github.com/ParkenDD/parkapi-sources-v3/pull/68) and
  [fixes in Karlsruhe converter](https://github.com/ParkenDD/parkapi-sources-v3/pull/75)

### Added

 * Reactivation of GBFS feed: stadtmobil_rhein-neckar


## 2024-07-16

### Changes

- ipl-dagster-pipeline is updated to [v2024-07-05t15-39](https://github.com/mobidata-bw/ipl-dagster-pipeline/blob/b8c202575e2ee4596c541cf4a7812c4a8fb81118/CHANGELOG.md#2024-07-05), this includes the following changes:
  - reduce CPU shares of GTFS import to 512 (https://github.com/mobidata-bw/ipl-dagster-pipeline/pull/140)
  - bump dagster to v1.7.12 and dagster-docker to v0.23.12 (https://github.com/mobidata-bw/ipl-dagster-pipeline/pull/155)
 * [ParkAPI 0.7.1 with new converters](https://github.com/ParkenDD/park-api-v3/blob/13c04ce93c0294bf162bc7d00130ba8f4b97c9d3/CHANGELOG.md#version-070)

### Added
* Add vector tiles support for layer `MobiData-BW:roadworks`.

### Fixes
- WFS: `sharing_station.capacity` is changed to an integer field, `vehicle.max_range_meters` and `vehicle.current_range_meters`, according to the [GBFS spec](https://github.com/MobilityData/gbfs/blob/cd75662c25180f68f76237f88a861d82e940cf3b/gbfs.md?plain=1#L1044), to float.
- WFS: `sharing_station_status` now reports vehicle availability for the feed's predominant `form_factor`, even for station, which don't have `vehicle_types_available` explicitly stated.

### Tasks

* Following docker image updates:
  * Lamassu: Upgrade from v2024-06-19T21-49 to v2024-07-08T06-22
  * `ipl-db`: Upgrade PostGIS from `15-3.3-alpine` to `15-3.4-alpine`


## 2024-07-09

### Changes
- GBFS Feed changes:
  - With Lamassu [v2024-06-17T13-28](https://github.com/entur/lamassu/blob/94db9e69fe841621617b91bc2948cb902475d5ca/Changelog.md), we now support GBFS 3.0. To request feeds in the new GBFS 3.0 version, instead of `sharing/gbfs` use `sharing/gbfs/v3/manifest.json`.
  - ⚠️ With Lamassu [v2024-06-17T13-28](https://github.com/entur/lamassu/blob/94db9e69fe841621617b91bc2948cb902475d5ca/Changelog.md), accessing feeds which are not yet retreived from upstream will return an http status 502 (BAD GATEWAY) instead of 404 (NOT FOUND).
  - my-e-car : added pricing plans for my-e-car (see [x2gbfs v2024-07-03](https://github.com/mobidata-bw/x2gbfs/blob/3c9f6c51aed7648c7f4a7f40858d08b63b739755/CHANGELOG.md#2024-07-03))
- ⚠️ In the GTFS API (`/gtfs`), all [`geography`](https://postgis.net/docs/manual-3.4/using_postgis_dbmanagement.html#PostGIS_Geography)-based columns have been changed from a hex encoding of the PostGIS-specific binary representation to [GeoJSON](https://geojson.org). If you depend on the current format of `shape_pt_loc` in `/gtfs/shapes` or `stop_loc` in `/gtfs/stops`, you will have to adapt your code. For example, the `stop_loc` format of stop `de:08231:50_Parent` (*Pforzheim Hauptbahnhof*) changes from `"0101000020E6100000D28BDAFD2A68214003098A1F63724840"` to `{"type":"Point","coordinates":[8.703453,48.89365]}`.
* ParkAPI: Disable the Loki integration.
	* Set `LOKI_ENABLED` to `false`. This can be overridden with a `$LOKI_ENABLED` environment variable.
	* Remove the default value for the `LOKI_URL` config, as it is only required if the Loki integration is enabled. The value was specific to MobiData BW's IPL deployment anyways, so we moved its definition into another (private) repo.
 * ipl-proxy: updated to 2024-07-10T14-11
 * x2gbfs: updated to 2024-07-15T12-14
 * Map URLs in `etc/index-page/index.html` updated


### Fixes

- GBFS Feeds:
  - Lime: for feeds of provider `Lime`, `station_status` and `station_information` feeds are from gbfs.json, as `Lime` associates all free floating bikes to a single station, which is semantically wrong (see [ipl-proxy v2024-06-19](https://github.com/mobidata-bw/ipl-proxy/blob/ab0f957b57fcf39335e7d4dff496272cba5bf1c4/CHANGELOG.md).
  - my-e-car, stadtmobil, lastenvelo_fr, voi_raumobil, deer: the vehicle_type.return_constraint was mis-spelled and is now fixed. (https://github.com/mobidata-bw/x2gbfs/pull/129)
  - nextbike: missing `max_range_meters` and `current_range_meters` are provided for `propulsion_type` != `human`.
  - bird: empty feeds `station_information`, `station_status` and `free_bike_status`, some of which have invalid lastUpdated values, have been removed.
* ParkAPI: Fixes an issue with missing ParkAPI realtime data (see [ParkAPI's v0.6.3 changelog](https://github.com/ParkenDD/park-api-v3/blob/0.6.3/CHANGELOG.md#version-063)).

### Added

 * Addition of GBFS feed: stadtmobil_rhein-neckar
 * Addition of `capacity` attribute to sharing stations layers as `java.lang.Integer` in Geoserver
 * Addition of `photo_url` attribute to `parking_sites` and `parking_sites_bicycle`

### Removed

* Removed GBFS feeds: bird-bulle, bird-uster, bird-winterthur, tier_rotkreuz

### Tasks

* Several docker image updates:
  * Lamassu: Upgrade from v2024-04-29T06-37 to v2024-06-19T21-49
  * Geoserver: Upgrade from 2.24.3 to 2.25.2 (see [geoserver/releases](https://github.com/geoserver/geoserver/releases/))
  * ParkAPI: Upgrade from 0.6.2 to 0.6.3 (see the [v0.6.3 changelog](https://github.com/ParkenDD/park-api-v3/blob/0.6.3/CHANGELOG.md#version-063))
  * Caddy: Upgrade from `2.8.1-alpine` to `2.8.4-alpine`
  * RabbitMQ: Upgrade from v3.12 to v3.13
  * Redis: Upgrade from `6-alpine` to `7-alpine`
  * Traefik: Upgrade from v2.11 to v3.1
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
