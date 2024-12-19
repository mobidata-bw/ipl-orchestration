-- see https://postgrest.org/en/stable/references/api/media_type_handlers.html
CREATE DOMAIN api."text/plain" AS text;

GRANT USAGE ON DOMAIN api."text/plain" TO postgrest;
