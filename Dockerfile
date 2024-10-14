# Gebruik Debian als basisimage
FROM debian:latest

# Update de package lijst en installeer restic, postgresql-client, en python
RUN apt-get update && \
    apt-get install -y wget gnupg2 lsb-release python3 python3-pip && \
    echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y restic postgresql-client-16 && \
    apt-get install -y curl && \
    apt-get install -y jq && \
    apt-get clean

COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh
COPY load_dump.sh /usr/local/bin/load_dump.sh
RUN chmod +x /usr/local/bin/load_dump.sh

# Voer de shell uit bij het starten van de container
CMD ["/bin/bash"]
