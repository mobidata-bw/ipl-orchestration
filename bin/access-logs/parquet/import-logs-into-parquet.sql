COPY (
	SELECT
		*
		EXCLUDE (
			req_nr,
			resp_size_bytes,
			duration_seconds,
			"timestamp"
		),
		-- todo: force Europe/Berlin tz here, via `getenv('TZ')`?
		date_trunc('day', "timestamp")::DATE AS "date",
		extract(hour FROM "timestamp") AS "hour",
		count(req_nr) AS nr_of_reqs,
		sum(resp_size_bytes) / 1000_000_000 AS resp_size_gb_sum,
		sum(duration_seconds) / 60 / 60 AS duration_hours_sum
	FROM (
		SELECT
			RequestCount AS req_nr,
			ClientHost AS client_ip,
			DownstreamStatus AS resp_status,
			DownstreamContentSize AS resp_size_bytes,
			OriginDuration / 1_000_000_000 AS duration_seconds,
			RequestMethod AS req_method,
			split_part(RequestPath, '/', 2) AS path_segment_1,
			split_part(RequestPath, '/', 3) AS path_segment_2,
			StartLocal::TIMESTAMPTZ AS "timestamp",
			"downstream_Content-Encoding" AS resp_content_encoding,
			"request_User-Agent" AS req_user_agent
		FROM read_json(
			getenv('TRAEFIK_ACCESS_LOG_FILENAME'),
			format='newline_delimited',
			records=True,
			sample_size=10000
		)
		WHERE True
		-- Traefik logs requests on all of its entrypoints, including the internal "admin" one, which in turn receives health check requests. We only want requests to the entrypoint for public consumption "web".
		AND entryPointName = 'web'
		-- We ignore requests from 10.70.{171,172}.20 (md-ipl-mon/md-ipl-p-mon) completely, given that they are either for monitoring or load tasting purposes.
		AND client_ip NOT IN ['10.70.171.20', '10.70.172.20']
		AND req_user_agent != 'OpenTripPlanner (MobiData BW)'
	) t
	GROUP BY
		"date",
		"hour",
		client_ip,
		resp_status,
		req_method,
		path_segment_1,
		path_segment_2,
		resp_content_encoding,
		req_user_agent
)
-- https://github.com/duckdb/duckdb/pull/18795
TO (getenv('PARQUET_FILENAME')) (
	FORMAT parquet,
	PARQUET_VERSION 'V2',
	COMPRESSION zstd
);
