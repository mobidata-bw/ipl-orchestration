-- Tell PostgreSQL that how to convert a PostGIS geography to a JSON string. PostgREST will pick this up when the user requested a JSON response.
CREATE OR REPLACE FUNCTION _geography_as_json(geography)
RETURNS json
AS $$
	SELECT ST_AsGeoJSON($1)::json;
$$
LANGUAGE SQL
IMMUTABLE;
CREATE CAST (geography AS json) WITH FUNCTION _geography_as_json(geography) AS IMPLICIT;
