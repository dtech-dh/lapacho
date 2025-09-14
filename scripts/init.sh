#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

# Actualizar sistema sin pedir confirmación
apt-get update
apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

# Instalar dependencias básicas
apt-get install -y apt-transport-https ca-certificates curl software-properties-common git ufw

# Instalar Docker
curl -fsSL https://get.docker.com | sh
usermod -aG docker $USER

# Instalar Docker Compose
DOCKER_COMPOSE_VERSION=2.29.2
curl -SL https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Habilitar UFW y permitir solo lo necesario
ufw default deny incoming
ufw default allow outgoing

# Permitir SSH (muy importante, de lo contrario te bloqueás)
ufw allow OpenSSH

# Permitir HTTP y HTTPS (para Nginx Proxy Manager y tus apps públicas)
ufw allow 80
ufw allow 443

# Si usás el panel de Nginx Proxy Manager (81)
ufw allow 81

# Si usás Portainer (9000)
ufw allow 9000

# Activar firewall
ufw --force enable

# Ver estado
ufw status verbose

echo "✅ Droplet inicializado con Docker y Compose"
