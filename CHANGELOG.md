# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),


## [Unreleased, planned for 2024-05-07]

### Added

-

### Changed

-

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