#!/bin/bash

# --- Variabel ---
SIRION_IP="192.230.3.2"
LINDON_IP="192.230.3.5"
VINGILOT_IP="192.230.3.6"
DOMAIN="k38.com"
NGINX_CONF="/etc/nginx/sites-available/sirion.${DOMAIN}"
ADMIN_USER="admin"
ADMIN_PASS="ainur"

# --- 1. Restart Apache di backend ---
echo "[*] Restart Apache backend..."
ssh root@$LINDON_IP "service apache2 restart"
ssh root@$VINGILOT_IP "service apache2 restart"

# --- 2. Install Nginx di Sirion ---
echo "[*] Install Nginx di Sirion..."
apt update
apt install nginx -y
service apache2 stop
service nginx start

# --- 3. Buat direktori admin ---
mkdir -p /var/www/html/admin
echo "<h1>Welcome to Admin Panel</h1>" > /var/www/html/admin/index.html

# --- 4. Setup Basic Auth otomatis ---
# Hapus dulu kalau ada file lama
[ -f /etc/nginx/.htpasswd ] && rm /etc/nginx/.htpasswd
# Buat password admin
printf "${ADMIN_USER}:$(openssl passwd -apr1 ${ADMIN_PASS})\n" > /etc/nginx/.htpasswd

# --- 5. Buat konfigurasi Nginx ---
cat > $NGINX_CONF <<EOL
server {
    listen 80;
    server_name www.${DOMAIN};

    access_log /var/log/nginx/sirion_access.log;
    error_log /var/log/nginx/sirion_error.log;

    # PATH-BASED ROUTING
    location /static/ {
        proxy_pass http://${LINDON_IP}/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }

    location /app/ {
        proxy_pass http://${VINGILOT_IP}/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }

    # Admin Basic Auth
    location /admin/ {
        auth_basic "Admin Login";
        auth_basic_user_file /etc/nginx/.htpasswd;
        proxy_pass http://127.0.0.1/admin/;
    }

    # Redirect root ke /static/
    location = / {
        return 302 /static/;
    }
}

server {
    listen 80;
    server_name sirion.${DOMAIN} ${SIRION_IP};

    return 301 http://www.${DOMAIN}\$request_uri;
}
EOL

# --- 6. Aktifkan konfigurasi ---
ln -s $NGINX_CONF /etc/nginx/sites-enabled/
nginx -t
service nginx reload

# --- 7. Tes akses ---
echo "[*] Testing endpoints..."
curl -I http://localhost/static/
curl -I http://localhost/app/
curl -I http://localhost/admin/

