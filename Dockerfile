# Gebruik Debian als basisimage
FROM debian:latest

# Update de package lijst en installeer restic, postgresql-client, python3, kopia en borgbackup
RUN apt-get update && \
    apt-get install -y wget gnupg2 lsb-release curl jq && \
    echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y restic postgresql-client-16 && \
    apt-get clean

# Install Kopia via APT repository
RUN mkdir -p /etc/apt/keyrings && \
    curl -s https://kopia.io/signing-key | gpg --dearmor -o /etc/apt/keyrings/kopia-keyring.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/kopia-keyring.gpg] http://packages.kopia.io/apt/ stable main" > /etc/apt/sources.list.d/kopia.list && \
    apt-get update && \
    apt-get install -y kopia

# Install BorgBackup 1.4 via APT (PPA repository)
RUN apt-get install -y software-properties-common && \
    add-apt-repository ppa:costamagnagianfranco/borgbackup -y && \
    apt-get update && \
    apt-get install -y borgbackup=1.4.*

# Copy scripts
COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh
COPY kopia_backup.sh /usr/local/bin/kopia_backup.sh
RUN chmod +x /usr/local/bin/kopia_backup.sh
COPY load_dump.sh /usr/local/bin/load_dump.sh
RUN chmod +x /usr/local/bin/load_dump.sh

# Voer de shell uit bij het starten van de container
CMD ["/bin/bash"]
