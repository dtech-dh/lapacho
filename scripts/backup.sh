#!/bin/bash
set -e

BACKUP_DIR="/srv/backups"
DATE=$(date +"%Y%m%d_%H%M%S")
OUTPUT="$BACKUP_DIR/docker_volumes_$DATE.tar.gz"

mkdir -p $BACKUP_DIR

echo "📦 Creando backup de volúmenes en $OUTPUT..."

# Detener contenedores antes del backup (opcional, más seguro)
# docker stop $(docker ps -q)

# Backup de todos los volúmenes
docker run --rm \
  -v /var/lib/docker/volumes:/source:ro \
  -v $BACKUP_DIR:/backup \
  alpine tar -czf /backup/docker_volumes_$DATE.tar.gz -C /source .

echo "✅ Backup completado: $OUTPUT"
