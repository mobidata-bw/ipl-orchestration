\getenv gtfs_schema_raw GTFS_IMPORTER_FINAL_SCHEMA
\set gtfs_schema '"' :gtfs_schema_raw '"'
\set geoserver_schema '"' :gtfs_schema_raw '_geoserver"'

CREATE VIEW :geoserver_schema.stops AS
	SELECT *
	FROM :gtfs_schema.stops;
