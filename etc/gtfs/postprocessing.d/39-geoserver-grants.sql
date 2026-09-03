\getenv gtfs_schema_raw GTFS_IMPORTER_SCHEMA
\set geoserver_schema '"' :gtfs_schema_raw '_geoserver"'

GRANT USAGE ON SCHEMA :geoserver_schema TO postgrest;
GRANT SELECT ON ALL TABLES IN SCHEMA :geoserver_schema TO postgrest;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA :geoserver_schema TO postgrest;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA :geoserver_schema TO postgrest;
