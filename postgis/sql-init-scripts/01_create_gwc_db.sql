-- Create the user if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_catalog.pg_roles WHERE rolname = :'GWC_USER'
  ) THEN
    EXECUTE format('CREATE USER %I WITH PASSWORD %L', :'GWC_USER', :'GWC_PASS');
  END IF;
END
$$;

-- Create the database if it doesn't exist, owned by that user
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT datname FROM pg_database WHERE datname = :'GWC_DB'
  ) THEN
    EXECUTE format('CREATE DATABASE %I OWNER %I', :'GWC_DB', :'GWC_USER');
  END IF;
END
$$;
