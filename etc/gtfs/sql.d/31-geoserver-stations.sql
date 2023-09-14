CREATE MATERIALIZED VIEW geoserver.stations_with_served_routes AS
	SELECT
		station_id,
		-- todo: is there something faster than min()? we just want *any*
		min(station_name) AS station_name,
		ST_Centroid(ST_Collect(stop_locs)) AS centroid,
		-- todo: prefer "rail" (`2`) over "light rail" (`0`)
		min(route_type::int) AS min_route_type,
		json_object_agg(route_type, route_names) AS routes
	FROM (
		-- determine available routes for each (station, route_type)
		SELECT
			station_id,
			-- todo: is there something faster than min()? we just want *any*
			min(station_name) AS station_name,
			ST_Collect(array_agg(stop_loc::geometry)) AS stop_locs, -- todo: distinct by stop_id?
			route_type, -- todo: normalize into basic route type
			array_agg(DISTINCT route_name) AS route_names
		FROM (
			SELECT DISTINCT ON (stop_id, route_id)
				stop_loc,
				station_id,
				station_name,
				route_id,
				route_type,
				route_name
			FROM (
				SELECT
					st.stop_id,
					stops.stop_loc,
					coalesce(
						stops.parent_station,
						array_to_string((string_to_array(st.stop_id, ':'))[1:3], ':')
					) AS station_id,
					coalesce(
						stations.stop_name,
						stops.stop_name
					) AS station_name,
					r.route_id,
					route_type,
					coalesce(route_short_name, route_long_name) AS route_name
				FROM api.stop_times st
				JOIN api.trips t ON st.trip_id = t.trip_id
				JOIN api.routes r ON r.route_id = t.route_id
				JOIN api.stops stops ON stops.stop_id = st.stop_id
				LEFT JOIN api.stops stations ON stations.stop_id = stops.parent_station
				WHERE route_short_name NOT LIKE '%SEV%' -- no rail replacement service
				AND st.stop_id LIKE 'de:08%' -- only stops in DE-BW
			) t
		) t
		GROUP BY station_id, route_type
	) t
	GROUP BY station_id;

-- todo: index?
-- todo: spatial index?
