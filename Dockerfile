# Gebruik Debian als basisimage
FROM debian:latest

# Update de package lijst en installeer restic
RUN apt-get update && \
    apt-get install -y restic && \
    apt-get clean

COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh

# Voer de shell uit bij het starten van de container
CMD ["/bin/bash"]
