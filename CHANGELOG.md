# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),


## [Unreleased, planned for 2024-05-07]

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