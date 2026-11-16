\getenv gtfs_schema_raw GTFS_IMPORTER_SCHEMA
\set gtfs_schema '"' :gtfs_schema_raw '"'
SET search_path TO :gtfs_schema,public;

-- see https://postgrest.org/en/stable/references/api/media_type_handlers.html
CREATE DOMAIN "text/plain" AS text;

GRANT USAGE ON DOMAIN "text/plain" TO postgrest;
