CREATE MATERIALIZED VIEW geoserver.shapes_with_routes AS
	SELECT
		shape_id,
		min(shape) AS shape,
		route_type,
		array_to_string(array_agg(DISTINCT route_id), ', ') AS route_ids,
		array_to_string(array_agg(DISTINCT route_name), ', ') AS route_names
	FROM (
		SELECT DISTINCT ON (shape_id, route_id)
			shapes.shape_id,
			shape,
			routes.route_id,
			route_type, -- todo: normalize into basic route type?
			coalesce(route_short_name, route_long_name) AS route_name
		FROM api.shapes_aggregated shapes
		JOIN api.trips ON shapes.shape_id = trips.shape_id
		JOIN api.routes ON trips.route_id = routes.route_id
		WHERE route_short_name NOT LIKE '%SEV%'
	) t
	GROUP BY shape_id, route_type;

-- todo: primary/unique key?
-- todo: spatial index?
