# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),

## Unreleased


- [ParkAPI 0.24.0](https://github.com/ParkenDD/park-api-v3/blob/97a9f7293ad895a58d7539cfb771759addc81f46/CHANGELOG.md#0240)
  with an admin REST API for pushing sources and parking spots without ParkAPI Sources converter.
- GeoServer: add `realtime_data_outdated` to `MobiData-BW:sharing_stations_car`, `MobiData-BW:sharing_stations_bicycle` and `MobiData-BW:sharing_stations_cargo_bicycle`


### 20-06-02

- [ParkAPI 0.23.1](https://github.com/ParkenDD/park-api-v3/blob/6ac1413954fe5c484fe9d604364cf7c342e238e2/CHANGELOG.md#0231)
  with extended static data for Freiburg

## 20-05-27

### Changed

- `gtfs-api-docs`: upgrade to [`skriptfabrik/elements-cli:0.5.13`](https://github.com/skriptfabrik/elements-cli/commits/0.5.13)
- GeoServer: add parking spots to `MobiData-BW:park-api_car_buildings`, add more types to style `mdbw_park-api_bicycle_types`
- [2025-05-23T14-24](https://github.com/mobidata-bw/x2gbfs/blob/main/CHANGELOG.md#2025-05-23)
- [OCPDB 2.1.1](https://github.com/binary-butterfly/ocpdb/blob/35e70c0b3d8d7cd2151e54743166090c7462cc5c/CHANGELOG.md#version-210)
  with more efficient evse status updates, fixing BNetzA Cron and other small fixes

## 2025-05-20 2nd

### Changed

- Lamassu:
  - deactivate feed `mobility_ch` because of duplicate station_ids

## 2025-05-20

### Changed

- Lamassu:
  - add feed `lime_stuttgart`, `herrenberg_alf`, `herrenberg_fare`, `herrenberg_guelf`, `herrenberg_stadtrad`
  - remove feed `pickebike_fribourg`
  - Bump to [the 2025-05-12T15-10 release](https://github.com/entur/lamassu/releases/tag/2025-05-12T15-10), which includes
    - Fix: Use station coords for docked vehicles without coords [bump serialization id] https://github.com/entur/lamassu/pull/662
    - Feature/graphql subscriptions https://github.com/entur/lamassu/pull/670
  - Bump to Redis-8
- GeoServer:
	- change default style for `MobiData-BW:charge_points` to `mdbw_charge_points_dynamic`
   	- change bounding boxes and add attribute names for gtfs layers for `MobiData-BW:transit_shapes_with_routes`, `MobiData-BW:transit_stations_with_served_routes` and `MobiData-BW:transit_stops`
   	- remove restriction to Baden-Wuerttemberg for `MobiData-BW:transit_stations_with_served_routes`
- [ipl-proxy 2025-05-19T05-02](https://github.com/mobidata-bw/ipl-proxy/blob/main/CHANGELOG.md#2025-05-16)
- [⚠️ Breaking OCPDB 2.0](https://github.com/binary-butterfly/ocpdb/blob/5b0d8ceb455d9a7ba21ca465514e9e026fae696a/CHANGELOG.md#version-200)
    - With new config file layout
    - With new OpenTelemetry compatible logging system
    - With normalized naming schema for importers
    - With OpenData Swiss as data source
    - With Heilbronn Neckarbogen as data source
- [OCPDB 2.1](https://github.com/binary-butterfly/ocpdb/blob/4e8da81da52c8dbffb48acc1b30f3467ae2a8c17/CHANGELOG.md#features)
    - With simple filter mechanism for BNetzA operators
- [ParkAPI 0.23.0](https://github.com/ParkenDD/park-api-v3/blob/b01f82092548c0fb035e6303f05d3a1b29a7e407/CHANGELOG.md#0230)
    - With ParkingSite patch system
    - With Freiburg ParkingSpots
    - With Ulm Sensors ParkingSites and ParkingSpots
    - With ParkingSpot type support for Friedrichshafen Sensors


## 2025-05-13

### Changed

- GeoServer
	- add `realtime_data_outdated` attribute to ParkAPI layers
 	- add additional layer for outdated realtimedata to `mdbw_park-api_sites_occupancy` and `mdbw_park-api_sites_occupancy`
  	- add attribut descriptions to `MobiData-BW:park-api_bicycle`
  	- remove truck and bus capacity attributes from ParkAPI layers
  	- add charging capacity attributes to `MobiData-BW:park-api_car_on-street`
- activate OCPDB source `pforzheim`

## 2025-05-12

### Changed

- `dagster-pipeline`/`dagster-daemon`/`dagster-dagit`: upgrade to [`2025-05-09T14-13`](https://github.com/mobidata-bw/ipl-dagster-pipeline/blob/2025-05-09/CHANGELOG.md#2025-05-09)
- GTFS import: Allow manually resolving a domain name using `$IPL_GTFS_IMPORTER_EXTRA_HOST_HOSTNAME` & `$IPL_GTFS_IMPORTER_EXTRA_HOST_IP`.
  - This applies to the Compose services `gtfs-importer` and `dagster-pipeline`.
  - To make the GTFS import work with the *MobiData-BW IPL deployment*, we manually resolve the GTFS server's domain.
  - However, the IPL default configuration resolves `random.alt` (an RFC 6761 special-use domain) to `127.0.0.1`, so it shouldn't interfere with IPL setups elsewhere.
- GeoServer: reduce maxZoom levels for vector tile caching and add description to some layers
- [ParkAPI 0.21.3 fixing realtime updates](https://github.com/ParkenDD/park-api-v3/blob/8b0f03237a096fd462efefd482580b43a44aa640/CHANGELOG.md#0213)


## 2025-05-06

### Changed

- GeoServer
	- add new park-api layer `MobiData-BW:park-api_car_on-street` for on-street parking
 	- rename other existing layers like `MobiData-BW:park-api_car_buildings` (`MobiData-BW:parking_sites_car` before), `MobiData-BW:park-api_bicycle` (`MobiData-BW:parking_sites_bicycle` before) and `MobiData-BW:park-api_item` (`MobiData-BW:parking_sites_item` before)
  	- remove all parking sites from `MobiData-BW:park-api_car_buildings` with the type `ON_STREET`
  	- rename several styles like `mdbw_park-api_sites_occupancy` (`mdbw_parking_sites_default` before), `mdbw_parking_sites_types_bicycle` (`mdbw_park-api_bicycle_types` before), `mdbw_park-api_car_types` (`mdbw_parking_sites_types` before)
  	- add new `styles mdbw_park-api_spots_occupancy` and `mdbw_park-api_parking-object`
- [ipl-proxy 2025-05-06T05-07](https://github.com/mobidata-bw/ipl-proxy/blob/main/CHANGELOG.md#2025-05-05)
- [x2gbfs 2025-05-06T06-53](https://github.com/mobidata-bw/x2gbfs/blob/main/CHANGELOG.md#2025-05-06)

## 2025-04-29

### Changed

- remove invalid feed `donkey_le_locle` and empty feed `donkey_le_sion`
- [OCPDB 1.5.1 with Albwerk, Pforzheim and BNetzA API support](https://github.com/binary-butterfly/ocpdb/blob/4db1c82d72f324461909b7d36a70f5b6f25a4495/CHANGELOG.md#version-150)


## 2025-04-22

### Changed

- [ParkAPI 0.21.1](https://github.com/mobidata-bw/park-api-v3/blob/c9f08f533bdb5926be04d90a0aa569f30c9aed29/CHANGELOG.md#0211)
  This release introduces automated OpenAPI docs testing in integration tests.
- [ParkAPI 0.21.0](https://github.com/mobidata-bw/park-api-v3/blob/c9f08f533bdb5926be04d90a0aa569f30c9aed29/CHANGELOG.md#0210)
  This release is a major change, as it introduces parking spots.

## 2025-04-11

### Changed

- [ipl-proxy 2025-04-10T13-48](https://github.com/mobidata-bw/ipl-proxy/blob/main/CHANGELOG.md#2025-04-09)

## 2025-04-09

### Changed

- `ingress`: Configure Traefik's handling of CORS preflight requests to allow requests with a `Content-Type` header.
  - Since the Lamassu upgrade in the [2025-03-26 release](#2025-03-26), GraphQL requests must be sent to it using `POST`, which was not possible cross-origin due to CORS restrictions.
  - Sending a `User-Agent` is also allowed now.
  - CORS Clients (e.g. browsers) are now allowed to cache the preflight results for 1 hour.
- [x2gbfs 2025-04-08T14-06](https://github.com/mobidata-bw/x2gbfs/blob/main/CHANGELOG.md#2025-04-08)

## 2025-04-03

### Changed

- [x2gbfs 2025-04-03T08-11](https://github.com/mobidata-bw/x2gbfs/blob/main/CHANGELOG.md#2025-04-03)
- [Several smaller ParkAPI fixes](https://github.com/ParkenDD/park-api-v3/releases/tag/0.20.4)
- `goaccess`: upgrade GoAccess to [v1.9.4](https://goaccess.io/release-notes#release-1.9.4)
- remove deactivated feed `dott_schaffhausen`
- remove obsolete feed `callabike_ice`, which is not part of `callabike`

## 2025-03-26

### Changed

- ⚠️ Lamassu: Bump to [the 2025-03-19 release](https://github.com/entur/lamassu/releases/tag/2025-03-19T09-09), which
  - provides metrics for outdated feeds (https://github.com/entur/lamassu/pull/659)
  - fixes an issue with stations not declaring (optional) `isVirtualStation` (https://github.com/entur/lamassu/issues/655)
  – is a breaking change [because GraphQL requests must now be made via `POST`](https://github.com/entur/lamassu/blob/2025-03-19T09-09/Changelog.md?plain=1#L11)
- Dagster: Bump to [2025-03-15T08-20](https://github.com/mobidata-bw/ipl-dagster-pipeline/blob/d9e295224ce577aa2e577ebecb335b2efc5baaa4/CHANGELOG.md?plain=1#L5-L10)


## 2025-03-20

### Changed

- fix: reactivate voi_de feed

## 2025-03-18

### Added

- add MOQO provider coono
- add lime_hamburg, lime_frankfurt feeds

### Changed

- reactivate zem_ch feed
- [ipl-proxy 2025-03-18T06-25](https://github.com/mobidata-bw/ipl-proxy/blob/main/CHANGELOG.md#2025-03-10)
- [x2gbfs 2025-03-13T08-15](https://github.com/mobidata-bw/x2gbfs/blob/main/CHANGELOG.md#2025-03-13)
- remove deactivated GBFS feed `dott_st_gallen`
- GeoServer: add MatrixTileSet WebMercatorQuad for vector tile layer roadworks
- Lamassu: With the 2025-03-04 release, lamassu was upgraded to version [2025-03-01T04-51](https://hub.docker.com/layers/entur/lamassu/2025-03-01T04-51/images/sha256-742f539b77ded7173da2e5b66db922e8cd657d344531417de7e86cd5591fd7d5). This had side effects which clients need to adapt to:
  - Endpoint `/sharing/graphql` now only accepts `POST` requests. Sending GraphQL queries vie `GET` with `query` parameter is not supported any longer
  - the `graphiql` client needs to explicitly specify `/sharing/graphql` as `path` param, e.g. `https://<host:port>/sharing/graphiql?path=/sharing/graphql`


## 2025-03-11

### Changed

- [ParkAPI Sources: Fix and reduce validation errors in converters](https://github.com/ParkenDD/park-api-v3/blob/68b36bcbf75189a740085c1b6163c5c0e6bb222b/CHANGELOG.md#0203)


## 2025-03-04

### Changed

- GeoServer: fix image name in `.env` (`geoserver` -> `ipl-geoserver`), pulling the image should now be possible again
- GeoServer: hard-code platform `linux/amd64` because there are currently no other platforms supported
- `lamassu`: upgraded [`lamassu`](https://github.com/entur/lamassu) to [2025-03-01T04-51](https://hub.docker.com/layers/entur/lamassu/2025-03-01T04-51/images/sha256-742f539b77ded7173da2e5b66db922e8cd657d344531417de7e86cd5591fd7d5). This i.e. includes an internal refactoring which reduces redis memory usage and improves graphql performance. For details see https://github.com/entur/lamassu/blob/master/Changelog.md?plain=1#L9C64-L17
- [x2gbfs 2025-03-03T13-17:](https://github.com/mobidata-bw/x2gbfs/blob/main/CHANGELOG.md#2024-03-03)
  - fix: update `deer` pricing plans
  - round vehicle and station coords to at most six decimal places
  - some x2gbfs deployment related changes, see x2gbfs [CHANGELOG]((https://github.com/mobidata-bw/x2gbfs/blob/main/CHANGELOG.md#2024-03-03)) for these

## 2025-02-25

### Changed

- ⚠️ `gtfs-importer`: upgraded [`postgis-gtfs-importer`](https://github.com/mobidata-bw/postgis-gtfs-importer) to [`v5-2025-02-19T00.49.01-20c1b09`](https://github.com/mobidata-bw/postgis-gtfs-importer/tree/20c1b09) – This is a breaking change because future GTFS imports won't work without a manual migration step. Please run `docker compose --env-file .env --env-file .env.local exec gtfs-db /bin/sh -c 'env PGUSER="$POSTGRES_USER" PGPASSWORD="$POSTGRES_PASSWORD" psql gtfs_importer -1 -c "CREATE TABLE IF NOT EXISTS latest_successful_imports (db_name TEXT PRIMARY KEY, imported_at INTEGER NOT NULL, feed_digest TEXT NOT NULL); INSERT INTO latest_successful_imports (db_name, imported_at, feed_digest) SELECT db_name, split_part(db_name, '\''_'\'', 2)::integer AS imported_at, split_part(db_name, '\''_'\'', 3) AS feed_digest FROM latest_import"'` to adapt the `gtfs_importer` database to the new way `postgis-gtfs-importer` keeps track of the imports (a table `latest_successful_imports`).
- GeoServer: add `naturenergie_sharing` to `mdbw_sharing_stations_default` with static data and other minor changes
- GeoServer: switch to [a custom Docker image](https://github.com/mobidata-bw/ipl-geoserver/pkgs/container/ipl-geoserver) that [already includes the vector tiles plugin and INSPIRE plugin](https://github.com/mobidata-bw/ipl-geoserver/blob/7c7d262f5a906798176a7306e51f46f679b12d84/Dockerfile#L14), so that the container doesn't have to download the plugin at runtime anymore.
- [ParkAPI 0.20.2](https://github.com/ParkenDD/park-api-v3/blob/002de448407ad2aaa2359f644990225f736e972a/CHANGELOG.md#0202)
  fixing an issue with client certificates being reused in follow-up-request, leading to a fail of `bahn_v2` converter
- ⚠️ [ParkAPI 0.20.0](https://github.com/ParkenDD/park-api-v3/blob/002de448407ad2aaa2359f644990225f736e972a/CHANGELOG.md#0200)
  with a new, abstract Datex II approach. This means that expected config values for `vrs_*` converters have to be
  converted to the new, abstract format. If you don't use VRS converters, no change is necessary.
- [ParkAPI 0.20.0](https://github.com/ParkenDD/park-api-v3/blob/002de448407ad2aaa2359f644990225f736e972a/CHANGELOG.md#0200)
  with [a new debug mode](https://github.com/ParkenDD/park-api-v3/blob/002de448407ad2aaa2359f644990225f736e972a/README.md#debugging-data-sources).

## 2025-02-12

### Changed

- `ingress`: adapt `gtfs-api` docs redirect rules to Traefik v3 syntax
- `gtfs-api`: upgrade [`postgrest/postgrest`](https://hub.docker.com/_/traefik) to [`v12.2.8`](https://hub.docker.com/layers/postgrest/postgrest/v12.2.8/images/sha256-914f1e934017ac8e27f66b4264d7ad2609aead8d84ae772832c7550477ac4d20)
- `ingesss`: upgrade [`traefik`](https://hub.docker.com/_/traefik) to [`v3.3`](https://hub.docker.com/layers/library/traefik/v3.3/images/sha256-ddd31b82ff1d4678974ef6dbc19796dee0185ae79fcb751f9cd9df40287e847f)
- `caddy`: upgrade [`caddy`](https://hub.docker.com/_/caddy) to [`2.9.1-alpine`](https://hub.docker.com/layers/library/caddy/2.9.1-alpine/images/sha256-c1b2ca303d5fe9c33f74c571066b35a087c3d2501463454cc02e252371222d8b)

## 2025-02-11

### Changed
- remove `INSPIRE` plugin from GeoServer
- GeoServer: several changes related to vector tiles
- [Duplicate query: Add source_id and source_uid: ParkAPI](https://github.com/ParkenDD/park-api-v3/blob/835db0601821daae82c16a7c2d72641dd574072e/CHANGELOG.md#0190)


## 2025-02-04 2nd

### Changed

- [ParkAPI: Hotfix ParkAPI OpeningTime output for ParkAPI v1](https://github.com/ParkenDD/park-api-v3/blob/dca14b8195cb015f8e5076bce79d46861445c604/CHANGELOG.md#0181)


## 2025-02-04

### Added

- [ipl-proxy: add converter for `gbfs.api.ridedott.com` feeds](https://github.com/mobidata-bw/ipl-proxy/blob/main/CHANGELOG.md#2025-01-29)

### Changed

- [ipl-proxy: replace converter for `gbfs.prod.sharedmobility.ch/v2/gbfs/mobility` feed](https://github.com/mobidata-bw/ipl-proxy/edit/main/CHANGELOG.md#2025-01-24)
- [dagster-pipeline/dagster-daemon/dagster-dagit: upgrade to `2025-01-28T15-57`](https://github.com/mobidata-bw/ipl-dagster-pipeline/blob/main/CHANGELOG.md#2025-01-28)
- [ParkAPI: Switch to Alpine base image and Python 3.12](https://github.com/ParkenDD/park-api-v3/blob/454c2418eca7e938e0c5f7af5fd3f372a049ea63/CHANGELOG.md#0180)
- [ParkAPI Sources: Add required attributes at several converters](https://github.com/ParkenDD/park-api-v3/blob/454c2418eca7e938e0c5f7af5fd3f372a049ea63/CHANGELOG.md#fixes)


## 2025-01-28

### Added

- [x2gbfs 2024-12-19: add Cantamen provider teilauto_schwaebisch_hall](https://github.com/mobidata-bw/x2gbfs/blob/main/CHANGELOG.md#2024-12-19)
- GeoServer: add vector tile caching to all layers, edit sql statement of `MobiData-BW:charge_points`, change bounding boxes of `MobiData-BW:charge_points` and `MobiData-BW:transit_shapes_with_routes`
- [OCPDB 1.3: Mitigate OCPI compatibility issues](https://github.com/binary-butterfly/ocpdb/blob/cc53f403c32e8d9a645064b36f22b9b3992060f5/CHANGELOG.md#version-130)

⚠️ The OCPDB changes might have effects on clients, as it changes the type of `id` from integer (which was wrong) to
string in OCPDBs public JSON output, and creates a clear logic how to name upstream field identifiers. More details on
that can be found [at the issue](https://github.com/binary-butterfly/ocpdb/issues/81).

The OCPI changes also introduce a new `strict` mode: with `?strict=true`, you will get OCPI objects without
additional attributes.


### Changed

- `gtfs-api`: Upgrade PostgREST from 12.2.3 to [12.2.5](https://github.com/PostgREST/postgrest/releases/tag/v12.2.5)
- [ParkAPI 0.17.3: Better sources output and documentation](https://github.com/ParkenDD/park-api-v3/blob/c9822011c8808349d528ae7e2af2d86f7a66834f/CHANGELOG.md#0173)


## 2025-01-21

### Added

- [ParkAPI: Add plausibility check for realtime_free_capacity values](https://github.com/ParkenDD/park-api-v3/blob/c92c028b0f97bbfe3c40a0c708d7042a555ea225/CHANGELOG.md#features)
- [ParkAPI Sources: Add VRN Park and Ride Realtime Converter](https://github.com/ParkenDD/park-api-v3/blob/c92c028b0f97bbfe3c40a0c708d7042a555ea225/CHANGELOG.md#features)
- [ParkAPI Sources: Add bahnv2 bike parking locked and open](https://github.com/ParkenDD/park-api-v3/blob/c92c028b0f97bbfe3c40a0c708d7042a555ea225/CHANGELOG.md#features)
- add dott_heilbronn GBFS feed

### Changed

- [ParkAPI Sources: opendata_swiss: change to new source_url](https://github.com/ParkenDD/park-api-v3/blob/c92c028b0f97bbfe3c40a0c708d7042a555ea225/CHANGELOG.md#fixes-2)
- OCPDB: Fix issue [with missing field at sw_stuttgart](https://github.com/binary-butterfly/ocpdb/blob/86cdd0d46afc5970a92458b5a0b306013958b605/CHANGELOG.md#version-123)


## 2025-01-15

### Added
- add dott de and dott ch feeds


## 2025-01-07

### Added
- GeoServer: added ferry and funicular to `mdbw_transit_stations_default` and `mdbw_transit_routes_default` gtfs styles
- OCPDB 1.2 with Stadtwerke Stuttgart
- OCPDB 1.2 with cron mechanisms for permanent data pulling

### Changed

- Centralize rabbitmq for better performance
- Improve rabbitmq healthcheck for better performance
- upgrade OCPDB to 1.2.1 with BNetzA Import Fix
- `dagster-pipeline`/`dagster-daemon`/`dagster-dagit`: upgrade to [`2024-12-03t09-35`](https://github.com/mobidata-bw/ipl-dagster-pipeline/blob/7ceecb4f622dc3a6ac9e6a3179885b4d17b62301/CHANGELOG.md#2024-12-03)
- `lamassu`: upgraded [`lamassu`](https://github.com/entur/lamassu) to [2024-12-17T19-37](https://hub.docker.com/layers/entur/lamassu/2024-12-17T19-37/images/sha256-7fb67b8f7a7395a9ec726dda7ed411679ef900fe0c4f3ec2da636cd4da5f603a). This i.e. includes immediate update after successful feed subscription (https://github.com/entur/lamassu/pull/592). As consequence, `X2GBFS_HEALTHCHECK_START_INTERVAL` is not necessary any longer and has been removed.
- `gtfs-api`: fix `gtfs_data_imported_at` Prometheus metric:
  - fix the format
  - grant access to the PostgreSQL function to PostgREST
  - move `text/plain` PostgreSQL domain into the `api` schema
- [ParkAPI 0.16.4 with fixes in Loki at Celery and Celery Crontab](https://github.com/ParkenDD/park-api-v3/blob/1227d469f877bf7a9b257cee3be6ea9e1531454e/CHANGELOG.md#0164)
- [ParkAPI 0.16.5 with fixes in config loading](https://github.com/ParkenDD/park-api-v3/blob/2076f5863d655fae1090350903d7cabc54427a70/CHANGELOG.md#0165)
- [x2gbfs 2024-12-19: rename stadtmobil_suedbaden to naturenergie_sharing](https://github.com/mobidata-bw/x2gbfs/blob/main/CHANGELOG.md#2024-12-19)


## 2024-12-20
### Added
- add `agency_id`, `agency_name` and `agency_url` to materialized view `shapes_with_routes`
- add GBFS providers donkey_bamberg, donkey_kiel, donkey_regensburg, donkey_le_locle, nextbike_nn

### Added
- add `agency_id`, `agency_name` and `agency_url` to materialized view `shapes_with_routes`
- add GBFS providers donkey_bamberg, donkey_kiel, donkey_regensburg, donkey_le_locle, nextbike_nn

### Changed
- remove obsolete GBFS providers tier_basel, tier_bern, tier_stgallen, tier_winterthur, tier_zurich


## 2024-12-11

### Added
- add MOQO providers flinkster_carsharing, oberschwabenmobil, gmuend_bewegt

### Changed
- VRS parking providers obtain new Mobilithek subscription ids


## 2024-12-10

### Added

- `gtfs-api`: Expose GTFS import date+time (`SELECT gtfs_data_imported_at()`) as a Prometheus metric under `/gtfs/rpc/gtfs_data_imported_at_metric`.

### Changed

- new namespace for GBFS feed voi_de to avoid conflict with voi_ch


## 2024-12-04

### Changed

- [ParkAPI 0.16.1](https://github.com/ParkenDD/park-api-v3/blob/908d1c4fe912ad3c7076098e20899458eb0db0c4/CHANGELOG.md#0161) with
  - Better logging and exception handling at converters
  - Moving access to static data to the night
  - Extended data at Kienzler source (GeoJSON PATCH system)
  - Better validation and therefore more valid parking sites at OpenData Swiss
  - Fix datetime format of Karlsruhe because they changed it
  - Code cleanup and other smaller improvements
- [ParkAPI 0.16.2 with a fix for static data imports via celery heartbeat](https://github.com/ParkenDD/park-api-v3/blob/451b1f511f377efbfb4552123070be6aff754dae/CHANGELOG.md#0162)


## 2024-11-20

### Changed

- [ParkAPI 0.15.3 Hotfix with a required database migration](https://github.com/ParkenDD/park-api-v3/blob/3a8fb1dd526b0def3d96790045d90daa05940beb/CHANGELOG.md)


## 2024-11-19

### Added
- add Cantamen provider gruene-flotte_freiburg
- add GBFS feed voi_de

### Changed

- deactivate GBFS feed voi_karlsruhe
- `ingesss`: upgraded [`traefik`](https://hub.docker.com/_/traefik) to [`v3.2`](https://hub.docker.com/layers/library/traefik/v3.2/images/sha256-e8a75d3640365b5a9f2b5fbcd8c745becdceabf3b7dc4e202094fb2bf03c1d37?context=explore)
- fix `natural order without a primary key` exception for layer transit_stations_with_served_routes
- `lamassu` container now depends on `x2gbfs` container startup, so feeds read from file system can be created before lamassu starts. To make sure all feeds have been created, set `X2GBFS_HEALTHCHECK_START_INTERVAL` to e.g. `60s`. For production use
- [Several ParkAPI Fixes](https://github.com/ParkenDD/park-api-v3/blob/fe93f699b3d6764c23fa7da8b00c7040865eb80f/CHANGELOG.md#0152)
- updated `mdbw_sharing_stations_default` style as `feed_id`s of static carsharing feeds changed


## 2024-11-05

### Changed
- deactivate Cantamen provider `my-e-car`

## 2024-10-30

### Changed

- ⚠️ `gtfs-importer`: upgraded [`postgis-gtfs-importer`](https://github.com/mobidata-bw/postgis-gtfs-importer) to [`v4-2024-10-24T17.43.02-76b148e`](https://github.com/mobidata-bw/postgis-gtfs-importer/tree/76b148e) – This is a breaking change because it switches the GTFS import back (from keeping all of them) to retaining only 2 databases, similar to the old (2024-09-17) behaviour of keeping only the most recent ones.
- `gtfs-importer`: work around [possible GTFS download bug in `postgis-gtfs-importer`](https://github.com/mobidata-bw/postgis-gtfs-importer/issues/10) by using plain `curl`
- GeoServer: rollback from version `2.26.0` to `2.25.3`
- ParkAPI 0.15.1 with [minor fixes and plugin maintenance](https://github.com/ParkenDD/park-api-v3/blob/bdd2c5a5596403220696fdb9e33b6ce5bc9ba842/CHANGELOG.md#0151)
- x2gbfs: updated to 2024-10-28T06-10


## 2024-10-17

### Added
- GeoServer: added descriptions to `parking_sites` attributes; updated `MobiData-BW:mdbw_sharing_stations_default` for current and upcoming static GBFS feeds

- ParkAPI 0.15.0 with new [Kienzler VVS Converter](https://github.com/ParkenDD/park-api-v3/blob/cf3b138151fd52b94cb2668ae34f9037a4d7be9c/CHANGELOG.md#0150)

### Changed
- GeoServer: updated GeoServer from 2.25.3 to 2.26.0; renamed `parking_sites` to `parking_sites_car`

- ParkAPI 0.15.0 with several [converter enhancements and fixes](https://github.com/ParkenDD/park-api-v3/blob/cf3b138151fd52b94cb2668ae34f9037a4d7be9c/CHANGELOG.md#0150)
- x2gbfs: updated to 2024-10-17T09-25

## 2024-10-08

### Added
- ParkAPI: added 26 units for provider kienzler_bike_and_ride

### Changed
- `lamassu`: upgraded [`lamassu`](https://github.com/entur/lamassu) to [2024-09-27T11-21](https://hub.docker.com/layers/entur/lamassu/2024-09-27T11-21/images/sha256-0f849baac422c1af11e2844e7dcd540a81a36414805e22c75243be2cea375a85?context=explore). This i.e. includes the `stationEntityCacheMinimumTtl` and `stationEntityCacheMaximumTtl`configuration options.
- [ParkAPI 0.14.3 with a fix at BFRK converter](https://github.com/ParkenDD/park-api-v3/blob/9061cdeaaa16a2336e2d7a874d7331f5c2c2d2bd/CHANGELOG.md#0143)
- `gtfs-importer`: upgraded [`postgis-gtfs-importer`](https://github.com/mobidata-bw/postgis-gtfs-importer) to [`v4-2024-10-03T22.54.08-d81cfdd`](https://github.com/mobidata-bw/postgis-gtfs-importer/tree/d81cfdd)

## 2024-10-01

### Added
- GeoServer: added `MobiData-BW:parking_sites_item` as a new layer
- GeoServer: `purpose` attribute added to `MobiData-BW:parking_sites_bicycle`

### Changed

- `gtfs-importer`: upgraded [`postgis-gtfs-importer`](https://github.com/mobidata-bw/postgis-gtfs-importer) to [`v4-2024-09-24T15.06.43-9a66d7d`](https://github.com/mobidata-bw/postgis-gtfs-importer/tree/9a66d7d)
- `gtfs-importer`: changed it not to remove redundant stops (i.e. with all fields being equal) before importing
- `gtfs-importer`: changed it to download GTFS datasets as `IPL (MobiData-BW)` (previously just `MobiData-BW`)
- GeoServer: updated style `mdbw_sharing_stations_default`
- GeoServer: updated `purpose` attribute in `MobiData-BW:parking_sites`
- `dagster-pipeline`/`dagster-daemon`/`dagster-dagit`: upgrade to [`2024-10-01T12-53`](https://github.com/mobidata-bw/ipl-dagster-pipeline/blob/f70996808fb4128cf6f5ceea4d7ac9be3646c614/CHANGELOG.md#2024-10-01)

## 2024-09-24

### Changed

- [ParkAPI 0.14.1 with multiple smaller fixes](https://github.com/ParkenDD/park-api-v3/blob/e9276c2d3f6c3c59f07088671223abe3ec2c28de/CHANGELOG.md#0141)
- [ParkAPI 0.14.2 with multiple smaller fixes](https://github.com/ParkenDD/park-api-v3/blob/e9276c2d3f6c3c59f07088671223abe3ec2c28de/CHANGELOG.md#0142)
- ipl-proxy: updated to 2024-09-17T05-58
- x2gbfs: updated to 2024-09-23T09-55

## 2024-09-17

### Added

- GBFS Feed nextbike_ae for Nextbike Strasbourg
- ParkAPI 0.14.0 with (Herrenberg Bike Converter)[https://github.com/ParkenDD/park-api-v3/blob/c196845d5de7419ce3753a498e9c5e943935427f/CHANGELOG.md#0140]

### Changes

- ParkAPI 0.14.0 with (Fixes at Documentation)[https://github.com/ParkenDD/park-api-v3/blob/c196845d5de7419ce3753a498e9c5e943935427f/CHANGELOG.md#0140]
- ParkAPI 0.14.0 with (Park and Ride at BFRK)[https://github.com/ParkenDD/park-api-v3/blob/c196845d5de7419ce3753a498e9c5e943935427f/CHANGELOG.md#0140]
- lamassu: updated to 2024-09-16T06-09. This i.e. includes the following changes:
  - https://github.com/entur/lamassu/pull/518: Add subscription update interceptor to add systemId to update logs
  - https://github.com/entur/lamassu/pull/530: Improve: allow configurable minimum max-age for cache-control directive
  - https://github.com/entur/lamassu/pull/527: Add bounding box search functionality to vehicles and stations queries
  - https://github.com/entur/lamassu/pull/516: Improve id validation (now conformant to GBFS spec)
  - https://github.com/entur/lamassu/pull/512: Map current_range_meters as provided instead of setting a missing value to 0.0


## 2024-09-10

### Added

- GBFS Feed for new carsharing provided flinkster added (via x2gbs version 2024-09-05T12-13)
- ParkAPI 0.13.0 with [new Hüfner Push Converter](https://github.com/ParkenDD/park-api-v3/blob/d59e1fe9dbc0e6203bf4b1d663c29c8dbe7c0156/CHANGELOG.md#features)
- GeoServer: Added `station_id` to `MobiData-BW:sharing_vehicles` and removed sharing stations where `station_id` is null
- GeoServer: Added the new category "Keine Echtzeitdaten" (no realtime data) to the `mdbw_sharing_stations_default` style
- GeoServer: Added an INSPIRE plugin


### Changes

- ParkApi 0.13.0 with [BFRK: Make URL configurable](https://github.com/ParkenDD/park-api-v3/blob/d59e1fe9dbc0e6203bf4b1d663c29c8dbe7c0156/CHANGELOG.md#fixes-1)
- ParkApi 0.13.0 with [Karlsruhe Bike: Ignore missing capacities](https://github.com/ParkenDD/park-api-v3/blob/d59e1fe9dbc0e6203bf4b1d663c29c8dbe7c0156/CHANGELOG.md#fixes-1)
- ParkApi 0.13.0 with [APCOA: Ignore missing coordinates](https://github.com/ParkenDD/park-api-v3/blob/d59e1fe9dbc0e6203bf4b1d663c29c8dbe7c0156/CHANGELOG.md#fixes-1)
- ParkApi 0.13.0 with [APCOA: Fix OSM Opening Times](https://github.com/ParkenDD/park-api-v3/blob/d59e1fe9dbc0e6203bf4b1d663c29c8dbe7c0156/CHANGELOG.md#fixes-1)
- ParkApi 0.13.1 with [has_fee True at all Heidelberg parking sites](https://github.com/ParkenDD/park-api-v3/blob/d59e1fe9dbc0e6203bf4b1d663c29c8dbe7c0156/CHANGELOG.md#fixes)
- ipl-proxy: updated to 2024-09-09T13-44
- x2gbfs: updated to 2024-09-10T05-57

## 2024-09-03

### Added

- ⚠️ ParkAPI 0.12.0 with [using BFRK API](https://github.com/ParkenDD/park-api-v3/blob/10fa3303ac21247a5ef1dc57cd9eb100bc18964f/CHANGELOG.md#featues).
  If you used the `bfrk` converters before, please make sure that you update your config.
- ParkAPI 0.12.0 with [max_with support](https://github.com/ParkenDD/park-api-v3/blob/10fa3303ac21247a5ef1dc57cd9eb100bc18964f/CHANGELOG.md#featues).


### Changes

- ParkAPI 0.12.0 with [dynamic Realtime Setting at Karlsruhe](https://github.com/ParkenDD/park-api-v3/blob/10fa3303ac21247a5ef1dc57cd9eb100bc18964f/CHANGELOG.md#fixes)
- ParkAPI 0.12.0 [fixing VRS UID mapping](https://github.com/ParkenDD/park-api-v3/blob/10fa3303ac21247a5ef1dc57cd9eb100bc18964f/CHANGELOG.md#fixes)
- ipl-proxy: updated to 2024-09-03T06-27
- x2gbfs: updated to :2024-09-03T06-22


## 2024-08-20

### Changes

- ParkAPI 0.10.0 with [Parking Site Groups](https://github.com/ParkenDD/park-api-v3/blob/9a02a9694bcda107bb5a8dd2100591b8ddc3b7d3/CHANGELOG.md#0100)
- ⚠️ ParkAPI 0.10.0 with [Kienzler SplitUp](https://github.com/ParkenDD/park-api-v3/blob/9a02a9694bcda107bb5a8dd2100591b8ddc3b7d3/CHANGELOG.md#0100).
  If you used the `kienzler` converter before, please make sure that you update your config.
- ParkAPI 0.11.0 with [new converters for Konstanz, Bondorf, Kirchheim, Neustadt and Vaihingen](https://github.com/ParkenDD/park-api-v3/blob/d7255dcb6d005202cbbca99817ab499db35469ef/CHANGELOG.md#0110)

### Fixes

- ParkAPI 0.10.0 with [Karlsruhe Converter Fix](https://github.com/ParkenDD/park-api-v3/blob/9a02a9694bcda107bb5a8dd2100591b8ddc3b7d3/CHANGELOG.md#0100)
- ParkAPI 0.10.0 with [SQL Query optimizations for faster responses](https://github.com/ParkenDD/park-api-v3/blob/9a02a9694bcda107bb5a8dd2100591b8ddc3b7d3/CHANGELOG.md#0100)
- ParkAPI 0.11.0 with [a fix for Kienzler split-up introduced in 0.10.0](https://github.com/ParkenDD/park-api-v3/blob/d7255dcb6d005202cbbca99817ab499db35469ef/CHANGELOG.md#0110)


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
