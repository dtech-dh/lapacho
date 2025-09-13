#!/bin/bash
set -e

echo "🔄 Actualizando imágenes y stacks en /srv..."

for d in /srv/*/ ; do
  if [ -f "$d/docker-compose.yml" ]; then
    echo "➡️  Actualizando stack en $d"
    cd "$d"
    docker-compose pull
    docker-compose up -d
  fi
done

echo "✅ Todos los stacks fueron actualizados."
