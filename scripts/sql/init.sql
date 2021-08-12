CREATE ROLE viewer;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO viewer;

ALTER SYSTEM SET log_statement = 'all';
SELECT pg_reload_conf();
