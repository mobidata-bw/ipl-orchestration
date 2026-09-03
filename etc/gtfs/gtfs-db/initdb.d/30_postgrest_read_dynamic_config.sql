CREATE SCHEMA IF NOT EXISTS postgrest;

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
	SELECT
		set_config('pgrst.' || name, val, true)
	FROM postgrest.config;
$$ LANGUAGE SQL;
