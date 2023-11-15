COMMENT ON SCHEMA "api" IS
$$REST-API für GTFS-Fahrplandaten

Diese API ist Teil der [MobiData-BW-Integrationsplattform](https://dev-ipl.mobidata-bw.de/). Sie ermöglicht Abfragen zu Haltestellen & Stationen, Ankünften & Abfahrten, Routen/Linien samt Fahrplantagen & Linienverläufen.

*Hinweis*: Wenn Ihr Anwendungsfall massenhafte Abfragen erfordern würde (bspw. eine Abfrage für jede Haltestelle), empfehlen wir Ihnen die Nutzung der [GTFS-Datensätze](https://mobidata-bw.de/dataset/?q=&res_format=GTFS&tags=GTFS).

Diese API wird von [PostgREST](https://postgrest.org/) zur Verfügung gestelt, welches auf eine mittels [gtfs-via-postgres](https://github.com/public-transport/gtfs-via-postgres) erstellte [PostgreSQL](https://www.postgresql.org)-Datenbank zugreift.
$$;
