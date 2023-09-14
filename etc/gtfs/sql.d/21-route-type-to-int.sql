-- Tell PostgreSQL that it can implicitly convert a route_type_val (e.g. `3`) to an integer just like it would convert a string `'3'`.
CREATE CAST (api.route_type_val AS integer) WITH INOUT AS IMPLICIT;
