CREATE MATERIALIZED VIEW geoserver.shapes_with_routes AS
	SELECT
		shape_id,
		st_setsrid(min(shape), 4326) AS shape,
		route_type,
		array_to_string(array_agg(DISTINCT route_id), ', ') AS route_ids,
		array_to_string(array_agg(DISTINCT route_name), ', ') AS route_names,
		agency.agency_id,
		agency.agency_name,
		agency.agency_url
	FROM (
		SELECT DISTINCT ON (shape_id, route_id)
			shapes.shape_id,
			shape,
			routes.route_id,
			route_type, -- todo: normalize into basic route type?
			coalesce(route_short_name, route_long_name) AS route_name,
			routes.agency_id
		FROM api.shapes_aggregated shapes
		JOIN api.trips ON shapes.shape_id = trips.shape_id
		JOIN api.routes ON trips.route_id = routes.route_id
		JOIN api.agency ON routes.agency_id = agency.agency_id
		WHERE route_short_name NOT LIKE '%SEV%'
	)
	JOIN api.agency ON t.agency_id = agency.agency_id
	GROUP BY shape_id, route_type, agency.agency_id, agency.agency_name, agency.agency_url;

-- allow filtering via Geoserver's CQL
-- todo: solve properly in gtfs-via-postgres, for all enums
DROP CAST IF EXISTS (api.route_type_val AS text);
CREATE CAST (api.route_type_val AS text) WITH INOUT AS ASSIGNMENT;

-- todo: primary/unique key?
CREATE INDEX shapes_with_routes_shape_idx
  ON geoserver.shapes_with_routes
  USING GIST (shape);
