-- Tell PostgreSQL that it can explicitly convert a route_type_val (e.g. `3`) to an integer just like it would convert a string `'3'`.
-- see also https://www.postgresql.org/docs/current/sql-createcast.html
-- see also https://stackoverflow.com/a/56746056/1072129
CREATE CAST (api.route_type_val AS integer) WITH INOUT AS ASSIGNMENT;
