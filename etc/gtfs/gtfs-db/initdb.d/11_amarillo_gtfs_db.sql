\getenv amarillo_gtfs_db_raw IPL_AMARILLO_GTFS_DB_POSTGRES_DB
\set amarillo_gtfs_db '"' :amarillo_gtfs_db_raw '"'

CREATE DATABASE :amarillo_gtfs_db;
