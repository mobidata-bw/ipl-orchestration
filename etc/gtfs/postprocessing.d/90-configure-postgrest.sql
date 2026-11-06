\getenv gtfs_schema_raw GTFS_IMPORTER_SCHEMA
-- \set gtfs_schema '"' :gtfs_schema_raw '"'
-- SET search_path TO :gtfs_schema,public;
\set gtfs_schema_escaped '\'' :gtfs_schema_raw '\''

UPDATE postgrest.config
SET val = :gtfs_schema_escaped
WHERE name = 'db_schemas';
