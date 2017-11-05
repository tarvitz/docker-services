#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d template1 <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS pg_trgm;
EOSQL

psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
    CREATE USER gitlab LOGIN CREATEDB;
    CREATE DATABASE gitlabhq_production OWNER gitlab;
    GRANT ALL PRIVILEGES ON DATABASE gitlabhq_production TO gitlab;
EOSQL
