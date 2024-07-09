-- Role: kartadmin
-- DROP ROLE IF EXISTS kartadmin;

CREATE ROLE kartadmin WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
  NOBYPASSRLS
  ENCRYPTED PASSWORD 'SCRAM-SHA-256$4096:/8YQlgCDNSNRDhVuqbdRHA==$t+MYxmbiulmaHuRSpmWRE17vse+XwILKDq94rt46+rs=:95dCXDbWBF9JZTnCG9AlKvBWLkoLu/l34osrfW/W1Qs=';

COMMENT ON ROLE kartadmin IS 'eKartka Administrator';
