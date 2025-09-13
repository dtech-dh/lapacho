
# 🌐 Infraestructura del Droplet 

Este repositorio contiene la definición de infraestructura y los scripts para **crear y configurar desde cero un Droplet en DigitalOcean**, instalar Docker, configurar firewall y desplegar los servicios base (Nginx Proxy Manager, Portainer y Watchtower).

Todo el proceso está automatizado con **Terraform** + **GitHub Actions**.

---

## 🚀 Flujo completo

1. **Terraform crea el Droplet** en DigitalOcean.
2. Obtiene automáticamente la **IP pública**.
3. GitHub Actions se conecta por SSH y ejecuta:
   - `scripts/init.sh` → instala Docker, Docker Compose, firewall.
   - `docker-compose.yml` → levanta servicios base (NPM, Portainer, Watchtower).

---

## 🔧 Requisitos previos

### 1. Generar clave SSH
En tu máquina local:
```bash
ssh-keygen -t ed25519 -C "tu-mail@empresa.com"
```

Esto genera:
- Clave privada → `~/.ssh/id_ed25519`
- Clave pública → `~/.ssh/id_ed25519.pub`

### 2. Subir la clave pública a DigitalOcean
- Ir a **DigitalOcean → Settings → Security → SSH Keys**.
- Subir el contenido de `id_ed25519.pub`.
- DigitalOcean asigna un **ID único** a esa clave (`ssh_key_id`).

Para verlo:
```bash
doctl compute ssh-key list
```

Ejemplo de salida:
```
ID          Name         Fingerprint
12345678    mi-clave     ab:cd:ef:...
```
En este caso, `DO_SSH_KEY_ID = 12345678`.

---

## 🔑 Secrets necesarios en GitHub

Configurar en **Settings → Secrets → Actions** del repo:

- `DIGITALOCEAN_ACCESS_TOKEN` → Token de DigitalOcean con permisos de lectura/escritura (se obtiene en [DigitalOcean API](https://cloud.digitalocean.com/account/api/tokens)).  
- `DO_SSH_KEY` → Clave privada SSH (`~/.ssh/id_ed25519`).  
- `DO_SSH_KEY_ID` → ID de la clave pública subida a DigitalOcean.  

---

## ▶️ Primer despliegue

1. Hacer `git push` a la rama `main`.
2. GitHub Actions ejecutará:
   - `terraform apply` → crea el Droplet.
   - Obtendrá la **IP pública** y la guardará en el job.
   - Conectará por SSH y correrá `init.sh` y `docker-compose.yml`.
3. El droplet quedará listo con:
   - **Firewall configurado** (puertos 22, 80, 81, 443, 9000).
   - **Docker + Compose instalados**.
   - **Servicios base** corriendo (NPM, Portainer, Watchtower).

---

## 🛠️ Scripts incluidos

- `scripts/init.sh` → Inicializa el Droplet (paquetes, Docker, firewall).  
- `scripts/update.sh` → Actualiza todos los stacks en `/srv/*`.  
- `scripts/backup.sh` → Backup de todos los volúmenes Docker en `/srv/backups`.  

---

## 🔒 Seguridad

- Firewall (UFW) habilitado: solo puertos 22, 80, 81, 443 y 9000.  
- Autenticación SSH solo con claves (no password).  
- Secrets seguros en GitHub.  

---

## 📌 Próximos pasos

- Crear carpetas para cada app en `/srv/appX` con su `docker-compose.yml`.  
- Configurar workflows de despliegue en los repos de apps para que se publiquen en el droplet.  
- Gestionar subdominios y certificados SSL desde **Nginx Proxy Manager**.

