#!/bin/bash

# Database variabelen
PG_USER="postgres"
PG_PASSWORD="postgres"
PG_HOST="postgresql"
DB_NAME="postgres"

pg_restore --no-owner -h $PG_HOST -U $PG_USER -d postgres /imdb-postgresql/imdb_pg11