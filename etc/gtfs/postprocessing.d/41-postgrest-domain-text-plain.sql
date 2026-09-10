SET search_path TO "api",public;

-- see https://postgrest.org/en/stable/references/api/media_type_handlers.html
CREATE DOMAIN "text/plain" AS text;

GRANT USAGE ON DOMAIN "text/plain" TO postgrest;
