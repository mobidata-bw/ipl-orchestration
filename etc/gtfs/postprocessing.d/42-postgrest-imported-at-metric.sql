CREATE OR REPLACE FUNCTION api.gtfs_data_imported_at_metric ()
RETURNS "text/plain"
AS $$
	SELECT 'gtfs_data_imported_at=' || floor(EXTRACT(EPOCH FROM api.gtfs_data_imported_at())) || E'\n';
$$ LANGUAGE SQL IMMUTABLE;
