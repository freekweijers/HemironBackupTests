#!/bin/bash

# Database variabelen
PG_USER="postgres"
PG_PASSWORD="postgres"
PG_HOST="postgresql"
DB_NAME="postgres"

# Borg variabelen
BORG_REPO="/backups/borg/repo"
BORG_PASSWORD="borg_password"
LOG_DIRECTORY="/backups/borg"
export BORG_PASSPHRASE=$BORG_PASSWORD  # Borg uses BORG_PASSPHRASE for encryption
export BORG_REPO=$BORG_REPO

# Map waar de SQL-bestanden zich bevinden
SQL_DIR="/sql_operations"  # Pas dit pad aan naar de locatie van je SQL-bestanden

# TSV-logbestand om back-up tijden op te slaan
BACKUP_LOG="/backups/borg/backups.tsv"  # Pas dit pad aan naar de locatie waar je het logbestand wilt opslaan
RECOVERY_LOG="/backups/borg/recovery.tsv"  # TSV-logbestand voor herstelprocessen

# Logbestand voor scriptuitvoer
LOG_FILE="/backups/borg_backup_log_$(date +'%Y%m%d_%H%M%S').log"

# check for existing repo - if yes, abort script
if borg check ${BORG_REPO}; then
    echo "repo exists"
    exit 1
else
    echo
    echo "Init Repostory:"
    borg init --encryption repokey ${BORG_REPO}
    echo
    echo "Exporting Key"
    borg key export ${BORG_REPO} ./key.txt
fi


# Schrijf de header voor het TSV-logbestand
echo -e "SQL File\tBackup Start Time\tBackup End Time\tDuration (seconds)\tBackup File Hash\tRepo Size (MB)" > "$BACKUP_LOG"
echo -e "Backup File\tRecovery Start Time\tRecovery End Time\tRecovery Duration (seconds)\tRecovered File Hash\tArchive Name" > "$RECOVERY_LOG"

# Redirect output to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Script gestart op $(date)"

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
      BACKUP_FILE="/tmp/${DB_NAME}_backup.dump"
      echo "Maak een pg_dump na uitvoeren van $SQL_FILE"
      pg_dump -h $PG_HOST -U $PG_USER -F c -b -v -f "$BACKUP_FILE" $DB_NAME

      # Tijd opnemen voor het starten van de back-up
      START_TIME=$(date +%s)
      BACKUP_START=$(date +"%Y-%m-%d %H:%M:%S")

      # Maak een back-up met Borg van de database dump
      echo "Back-up maken met Borg: $BACKUP_FILE"
      borg create "$BORG_REPO::backup_${i}_$(date +'%Y%m%d_%H%M%S')" "$BACKUP_FILE"

      # Tijd opnemen voor het einde van de back-up
      END_TIME=$(date +%s)
      BACKUP_END=$(date +"%Y-%m-%d %H:%M:%S")
      DURATION=$((END_TIME - START_TIME))

      # Bereken de hash van de back-up file
      BACKUP_HASH=$(sha256sum "$BACKUP_FILE" | awk '{ print $1 }')

      # Bereken de grootte van de Borg repository in MB
      REPO_SIZE=$(du -sm "$BORG_REPO" | awk '{ print $1 }')

      # Sla de back-up details op in het TSV-logbestand
      echo -e "$SQL_FILE\t$BACKUP_START\t$BACKUP_END\t$DURATION\t$BACKUP_HASH\t$REPO_SIZE" >> "$BACKUP_LOG"

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

# Herstelproces na het back-upproces
# Lijst alle Borg archives op
borg list "$BORG_REPO" --json | jq -c '.archives[]' | while read -r archive; do
  # Verkrijg de archiefnaam
  ARCHIVE_NAME=$(echo "$archive" | jq -r '.name')
  ARCHIVE_TIME=$(echo "$archive" | jq -r '.start')

  # Specificeer het bestand om te herstellen
  RECOVERED_FILE="/tmp/postgres_backup.dump"

  # Tijd opnemen voor het starten van het herstel
  RECOVERY_START_TIME=$(date +%s)
  RECOVERY_START=$(date +"%Y-%m-%d %H:%M:%S")

  # Herstel het back-upbestand met Borg
  echo "Herstellen van archive $ARCHIVE_NAME gemaakt op $ARCHIVE_TIME"
  borg extract "$BORG_REPO::$ARCHIVE_NAME"

  # Tijd opnemen voor het einde van het herstel
  RECOVERY_END_TIME=$(date +%s)
  RECOVERY_END=$(date +"%Y-%m-%d %H:%M:%S")
  RECOVERY_DURATION=$((RECOVERY_END_TIME - RECOVERY_START_TIME))

  # Bereken de hash van het herstelde bestand
  RECOVERED_HASH=$(sha256sum "$RECOVERED_FILE" | awk '{ print $1 }')

  # Sla de herstel details op in het recovery TSV-logbestand
  echo -e "$RECOVERED_FILE\t$RECOVERY_START\t$RECOVERY_END\t$RECOVERY_DURATION\t$RECOVERED_HASH\t$ARCHIVE_NAME" >> "$RECOVERY_LOG"

  # Opruimen van het herstelde bestand
  rm "$RECOVERED_FILE"
done

echo "Herstelproces voltooid."
