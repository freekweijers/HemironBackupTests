#!/bin/bash

# Database variabelen
PG_USER="postgres"
PG_PASSWORD="postgres"
PG_HOST="postgresql"
DB_NAME="postgres"

# Kopia variabelen
KOPIA_REPO="/backups/kopia"
KOPIA_PASSWORD="kopia_password"
export KOPIA_PASSWORD=$KOPIA_PASSWORD

# Map waar de SQL-bestanden zich bevinden
SQL_DIR="/sql_operations"  # Pas dit pad aan naar de locatie van je SQL-bestanden

# TSV-logbestand om back-up tijden op te slaan
BACKUP_LOG="/backups/kopia/backups.tsv"  # Pas dit pad aan naar de locatie waar je het logbestand wilt opslaan
RECOVERY_LOG="/backups/kopia/recovery.tsv"  # TSV-logbestand voor herstelprocessen

# Logbestand voor scriptuitvoer
LOG_FILE="/backups/kopia_backup_log_$(date +'%Y%m%d_%H%M%S').log"

# Initialiseer Kopia repository als deze nog niet bestaat
kopia repository create filesystem --path="$KOPIA_REPO" --password=$KOPIA_PASSWORD

# Schrijf de header voor het TSV-logbestand
echo -e "SQL File\tBackup Start Time\tBackup End Time\tDuration (seconds)\tBackup File Hash\tRepo Size (MB)" > "$BACKUP_LOG"
echo -e "Backup File\tRecovery Start Time\tRecovery End Time\tRecovery Duration (seconds)\tRecovered File Hash\tSnapshot ID" > "$RECOVERY_LOG"

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

      # Maak een back-up met Kopia van de database dump
      echo "Back-up maken met Kopia: $BACKUP_FILE"
      kopia snapshot create "$BACKUP_FILE"

      # Tijd opnemen voor het einde van de back-up
      END_TIME=$(date +%s)
      BACKUP_END=$(date +"%Y-%m-%d %H:%M:%S")
      DURATION=$((END_TIME - START_TIME))

      # Bereken de hash van de back-up file
      BACKUP_HASH=$(sha256sum "$BACKUP_FILE" | awk '{ print $1 }')

      # Bereken de grootte van de Kopia repository in MB
      REPO_SIZE=$(du -sm "$KOPIA_REPO" | awk '{ print $1 }')

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
# Lijst alle snapshots op
snapshots=$(kopia snapshot list --json)

# Loop door alle snapshots
echo "$snapshots" | jq -c '.[]' | while read -r snapshot; do
  # Verkrijg de snapshot ID
  SNAPSHOT_ID=$(echo "$snapshot" | jq -r '.id')
  SNAPSHOT_TIME=$(echo "$snapshot" | jq -r '.startTime')

  # Specificeer het back-upbestand om te herstellen
#  RECOVERED_FILE="/tmp/recovered_${SNAPSHOT_ID}.dump"

  # Tijd opnemen voor het starten van het herstel
  RECOVERY_START_TIME=$(date +%s)
  RECOVERY_START=$(date +"%Y-%m-%d %H:%M:%S")

  # Herstel het back-upbestand met Kopia
  echo "Herstellen van snapshot $SNAPSHOT_ID gemaakt op $SNAPSHOT_TIME"
  kopia snapshot restore "$SNAPSHOT_ID"
  BACKUP_FILE=$SNAPSHOT_ID

  # Tijd opnemen voor het einde van het herstel
  RECOVERY_END_TIME=$(date +%s)
  RECOVERY_END=$(date +"%Y-%m-%d %H:%M:%S")
  RECOVERY_DURATION=$((RECOVERY_END_TIME - RECOVERY_START_TIME))

  # Bereken de hash van het herstelde bestand
  RECOVERED_HASH=$(sha256sum "$BACKUP_FILE" | awk '{ print $1 }')

  # Sla de herstel details op in het recovery TSV-logbestand
  echo -e "$BACKUP_FILE\t$RECOVERY_START\t$RECOVERY_END\t$RECOVERY_DURATION\t$RECOVERED_HASH\t$SNAPSHOT_ID" >> "$RECOVERY_LOG"

  # Opruimen van het herstelde bestand
  rm "$BACKUP_FILE"
done

echo "Herstelproces voltooid."
