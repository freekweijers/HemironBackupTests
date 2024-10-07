#!/bin/bash

# Database variabelen
PG_USER="postgres"
PG_PASSWORD="postgres"
PG_HOST="postgresql"
DB_NAME="postgres"


#Inladen van voorgedownloadde dataset imdb
python3 ./imdb-postgresql/build.py --fast --pghost $PG_HOST

#
## Restic variabelen
#RESTIC_REPO="/backups"
#RESTIC_PASSWORD="restic_password"
#
## Maak een pg_dump van de IMDB-database
#export PGPASSWORD=$PG_PASSWORD
#pg_dump -h $PG_HOST -U $PG_USER -F c -b -v -f /tmp/${DB_NAME}_backup.dump $DB_NAME
#
## Initialiseer Restic repository als deze nog niet bestaat
#if [ ! -d "$RESTIC_REPO" ]; then
#    restic init --repo $RESTIC_REPO --password-file=/tmp/restic_password
#fi
#
## Maak een back-up met Restic van de database dump
#restic -r $RESTIC_REPO --password-file=/tmp/restic_password backup /tmp/${DB_NAME}_backup.dump
#
## Opruimen van tijdelijke bestanden
#rm /tmp/${DB_NAME}_backup.dump

