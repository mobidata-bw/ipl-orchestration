\getenv gtfs_schema_raw GTFS_IMPORTER_SCHEMA
\set gtfs_schema '"' :gtfs_schema_raw '"'
SET search_path TO :gtfs_schema,public;

CREATE OR REPLACE FUNCTION gtfs_data_imported_at_metric ()
RETURNS "text/plain"
SET search_path FROM current
AS $$
	SELECT E'# HELP gtfs_data_imported_at when the GTFS data has been imported\n# TYPE gtfs_data_imported_at gauge\ngtfs_data_imported_at ' || floor(EXTRACT(EPOCH FROM gtfs_data_imported_at())) || E'\n';
$$ LANGUAGE SQL IMMUTABLE;

GRANT EXECUTE ON FUNCTION gtfs_data_imported_at_metric TO postgrest;
