#!/bin/bash

# Database variabelen
PG_USER="postgres"
PG_PASSWORD="postgres"
PG_HOST="postgresql"
DB_NAME="postgres"

# Restic variabelen
RESTIC_REPO="/backups"
RESTIC_PASSWORD="restic_password"
export RESTIC_PASSWORD=$RESTIC_PASSWORD

# Map waar de SQL-bestanden zich bevinden
SQL_DIR="/sql_operations"  # Pas dit pad aan naar de locatie van je SQL-bestanden

# Initialiseer Restic repository als deze nog niet bestaat
restic init --repo $RESTIC_REPO

# Loop door de SQL-bestanden van 01.sql tot en met 10.sql
for i in $(seq -w 1 10); do
  SQL_FILE="$SQL_DIR/${i}.sql"

  if [ -f "$SQL_FILE" ]; then
    # Voer het SQL-bestand uit
    echo "Uitvoeren van $SQL_FILE"
    export PGPASSWORD=$PG_PASSWORD
    psql -h $PG_HOST -U $PG_USER -d $DB_NAME -f "$SQL_FILE"

    # Controleer of de SQL-uitvoering succesvol was
    if [ $? -eq 0 ]; then
      echo "$SQL_FILE succesvol uitgevoerd."

      # Maak een pg_dump van de database na de SQL-uitvoering
      BACKUP_FILE="/tmp/${DB_NAME}_backup_${i}.dump"
      echo "Maak een pg_dump na uitvoeren van $SQL_FILE"
      pg_dump -h $PG_HOST -U $PG_USER -F c -b -v -f "$BACKUP_FILE" $DB_NAME

      # Maak een back-up met Restic van de database dump
      echo "Back-up maken met Restic: $BACKUP_FILE"
      restic -r $RESTIC_REPO backup "$BACKUP_FILE"

      # Opruimen van tijdelijke bestanden
      rm "$BACKUP_FILE"
    else
      echo "Fout bij het uitvoeren van $SQL_FILE, script beëindigd."
      exit 1
    fi
  else
    echo "$SQL_FILE bestaat niet, script beëindigd."
    exit 1
  fi
done

echo "Alle SQL-bestanden uitgevoerd en back-ups gemaakt."
