\getenv gtfs_schema_raw GTFS_IMPORTER_SCHEMA
\set geoserver_schema '"' :gtfs_schema_raw '_geoserver"'

CREATE SCHEMA :geoserver_schema;
