\getenv gtfs_schema_raw GTFS_IMPORTER_FINAL_DB_SCHEMA
\set gtfs_schema_escaped '\'' :gtfs_schema_raw '\''

UPDATE postgrest.config
SET val = :gtfs_schema_escaped
WHERE name = 'db_schemas';
