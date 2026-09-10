SET search_path TO "api",public;

CREATE OR REPLACE FUNCTION gtfs_data_imported_at_metric ()
RETURNS "text/plain"
SET search_path FROM current
AS $$
	SELECT E'# HELP gtfs_data_imported_at when the GTFS data has been imported\n# TYPE gtfs_data_imported_at gauge\ngtfs_data_imported_at ' || floor(EXTRACT(EPOCH FROM gtfs_data_imported_at())) || E'\n';
$$ LANGUAGE SQL IMMUTABLE;

GRANT EXECUTE ON FUNCTION gtfs_data_imported_at_metric TO postgrest;
