CREATE OR REPLACE FUNCTION api.gtfs_data_imported_at_metric ()
RETURNS api."text/plain"
AS $$
	SELECT E'# HELP gtfs_data_imported_at when the GTFS data has been imported\n# TYPE gtfs_data_imported_at gauge\ngtfs_data_imported_at=' || floor(EXTRACT(EPOCH FROM api.gtfs_data_imported_at())) || E'\n';
$$ LANGUAGE SQL IMMUTABLE;
