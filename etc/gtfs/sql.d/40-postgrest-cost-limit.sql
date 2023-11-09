CREATE EXTENSION IF NOT EXISTS plan_filter;

-- Make sure plan_filter is auto-loaded whenever connecting to the current DB.
-- Note: `current_database()` cannot be used in `ALTER DATABASE`, so we use `EXECUTE`.
-- https://dba.stackexchange.com/a/78381

CREATE FUNCTION _alter_db (db TEXT, param TEXT, val TEXT)
RETURNS void
AS $$
	BEGIN
		EXECUTE format('ALTER DATABASE %I SET %I = %L', db, param, val);
	END
$$
LANGUAGE plpgsql;
-- effectively ALTER DATABASE current_database() SET session_preload_libraries = 'plan_filter';
SELECT _alter_db(current_database(), 'session_preload_libraries', 'plan_filter');
DROP FUNCTION _alter_db;

-- Each configuration parameter exists within a scope.
-- Configuration parameters like plan_filter.statement_cost_limit that exist in a *more secure* scope than `user` (e.g. `superuser` or `sighup`) *do not* get adapted when changing to a different role (`web_anon`) by impersonating it via `SET ROLE`!
-- > This is because according to the pg docs executing SET ROLE does not cause new configuration values to be set, this only happens at login time. I have an example of this here.
-- https://github.com/PostgREST/postgrest/issues/249#issuecomment-334629208
-- > The possible values of context are:
-- > - internal (called PGC_INTERNAL in source code)
-- > - postmaster (PGC_POSTMASTER)
-- > - sighup (PGC_SIGHUP)
-- > - backend (PGC_BACKEND)
-- > - superuser (PGC_SUSET)
-- > - user (PGC_USERSET)
-- > The above list is in order of when a parameter can be set; if a parameter can be changed in a certain context, then it can be changed at any of the earlier contexts as well.
-- https://www.enterprisedb.com/blog/understanding-postgres-parameter-context
-- > However if we want to set different statement_timeout for anon and web_user. […] These will not be picked up and their statement_timeout won't be enforced.
-- https://github.com/PostgREST/postgrest/issues/2561#issue-1436728326

-- However, we can still define a cost limit for operations on the *`postgrest` user* [1] (PostgREST uses it to connect to the DB, before switching to `web_anon`); PostgREST then re-applies it manually when it switches the role (`SET ROLE web_anon`) in each transaction [2].
-- Because that means that even PostgREST proper can't run very expensive queries (e.g. the schema introspection query at startup) anymore, we need to find a balance between not hindering PostgREST and preventing excessive queries by users. 1000000 is roughly equivalent to 0.2s-5s of execution time.
-- [1] https://postgrest.org/en/stable/references/auth.html#overview-of-role-system
-- [2] https://postgrest.org/en/stable/references/auth.html#impersonated-role-settings

-- This currently doesn't work as expected though, PostgREST doesn't seem to re-apply `plan_filter.statement_cost_limit` to `web_anon`. [3]
-- [3] https://github.com/PostgREST/postgrest/issues/3045

-- Limit postgrest's & web_anon's queries by the query planner's estimated cost.
ALTER ROLE postgrest SET plan_filter.statement_cost_limit = 1000000.0;
