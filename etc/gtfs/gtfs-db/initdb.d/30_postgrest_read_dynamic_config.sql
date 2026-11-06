CREATE SCHEMA IF NOT EXISTS postgrest;
-- GRANT USAGE ON SCHEMA postgrest TO postgrest;

CREATE TABLE IF NOT EXISTS postgrest.config (
	name TEXT PRIMARY KEY,
	val TEXT NOT NULL
);
INSERT INTO postgrest.config (name, val)
VALUES ('db_schemas', 'api')
ON CONFLICT (name) DO UPDATE SET val = EXCLUDED.val;

CREATE OR REPLACE FUNCTION postgrest.read_dynamic_config()
RETURNS VOID
AS $$
	-- WITH import AS (
	-- 	SELECT
	-- 		schema_name
	-- 	FROM latest_successful_imports_v2
	-- 	WHERE substring(schema_name FOR character_length('api_')) = 'api_'
	-- 	ORDER BY imported_at DESC
	-- )
	-- SELECT
	-- 	True
	-- 	, set_config('pgrst.db_schemas', schema_name, true)
	-- FROM import;

	-- WITH _db_schemas AS (
	-- 	SELECT
	-- 		val AS db_schemas
	-- 	FROM postgrest.config
	-- 	WHERE name = 'db_schemas'
	-- )
	-- SELECT
	-- 	set_config('pgrst.db_schemas', db_schemas, true)
	-- FROM _db_schemas;

	SELECT
		set_config('pgrst.' || name, val, true)
	FROM postgrest.config;
$$ LANGUAGE SQL;
