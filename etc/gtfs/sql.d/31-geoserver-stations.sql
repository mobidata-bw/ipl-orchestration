CREATE MATERIALIZED VIEW geoserver.stations_with_served_routes AS
	SELECT 
		station_id,
		station_name,
		-- prefer original parent station coord if available, else centroid of quays
		coalesce(s.stop_loc, centroid) centroid,
		prio_route_type,
		routes,
		render_prio
	 FROM (
		SELECT
			station_id,
			-- todo: is there something faster than min()? we just want *any*
			min(station_name) AS station_name,
			ST_Centroid(ST_Collect(stop_locs)) AS centroid,
			-- prio_encoded_route_type has a multiple of 10000 added, which determines render prio (less is higher prio)
			-- the last 4 digits represent the original route_type, so we need to modulo...
			mod(min(prio_encoded_route_type::int),10000) AS prio_route_type,
			json_object_agg(route_type, route_names) AS routes,
			-- prio_encoded_route_type has a multiple of 10000 added, which determines render prio (less is higher prio)
			min(prio_encoded_route_type::int) / 10000 AS render_prio
		FROM (
			-- determine available routes for each (station, route_type)
			SELECT
				station_id,
				-- todo: is there something faster than min()? we just want *any*
				min(station_name) AS station_name,
				ST_Collect(array_agg(stop_loc::geometry)) AS stop_locs, -- todo: distinct by stop_id?,
				route_type,
				-- todo: in case the feed uses extended route_types, these need to be handled here also
				case when route_type=0 then '20000' when route_type=2 then '10002' when route_type between 3 and 9 then '3000'||route_type else '9000'||route_type end prio_encoded_route_type,
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
		GROUP BY station_id
	) t 
	LEFT JOIN api.stops s ON s.stop_id = t.station_id
	;


-- todo: index?
-- todo: spatial index?
