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
				case
					when route_type::int between 100 and 117 then '1000100' -- Railway Service: render_prio = 100, prio_route_type = 100
					when route_type::int between 200 and 209 then '5000200' -- Coach Service: render_prio = 500, prio_route_type = 200
					when route_type::int between 400 and 405 then '2000400' -- Urban Railway Service: render_prio = 200, prio_route_type = 400
					when route_type::int between 700 and 716 then '4000700' -- Bus Service: render_prio = 400, prio_route_type = 700
					when route_type::int = 800 then '4000800' -- Trolleybus Service: render_prio = 400, prio_route_type = 800
					when route_type::int between 900 and 906 then '3000900' -- Tram Service: render_prio = 300, prio_route_type = 900
					when route_type::int = 1000 then '7001000' -- Water Transport: render_prio = 700, prio_route_type = 1000
					when route_type::int = 1200 then '7001200' -- Ferry Service: render_prio = 700, prio_route_type = 1200
					when route_type::int between 1300 and 1307 then '8001300' -- Aerial Lift Service: render_prio = 800, prio_route_type = 1300
					when route_type::int = 1400 then '8001400' -- Funicular Service: render_prio = 800, prio_route_type = 1400
					when route_type::int between 1500 and 1507 then '6001500' -- Taxi Service: render_prio = 600, prio_route_type = 1500
					when route_type::int = 1700 then '9001700' -- Miscellaneous Service: render_prio = 900, prio_route_type = 1700
					when route_type::int < 11 then '1000000' || route_type::int -- Irregular route types below 100: render_prio = 1000, prio_route_type = 0 - 7
					when route_type::int between 11 and 12 then '100000' || route_type::int -- Irregular route types below 100: render_prio = 1000, prio_route_type = 11 - 12
					--- Air Service (1100) -> 10001100: render_prio = 1000, prio_route_type = 1100
					--- Horse-drawn Carriage (1702) -> 10001702: render_prio = 1000, prio_route_type = 1702
					else '1000' || route_type::int	
				end prio_encoded_route_type,
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
					--AND st.stop_id LIKE 'de:08%' -- only stops in DE-BW
				) t
			) t
			GROUP BY station_id, route_type
		) t
		GROUP BY station_id
	) t 
	LEFT JOIN api.stops s ON s.stop_id = t.station_id
	;

CREATE UNIQUE INDEX stations_with_served_routes_idx ON geoserver.stations_with_served_routes(station_id);
-- todo: spatial index?
