#!/bin/bash

#Sirion

echo "🔐 Setting up Basic Auth for /admin on Sirion..."

# Step 1: Install required packages
echo "🔄 Installing packages..."
apt-get update
apt-get install -y apache2 apache2-utils
echo "✅ Packages installed"

# Step 2: Create password file
echo "🔄 Creating password file..."
htpasswd -cb /etc/apache2/.htpasswd admin ainur
echo "✅ Password file created"

# Step 3: Verify password file
echo "🔍 Verifying password file..."
cat /etc/apache2/.htpasswd

# Step 4: Update virtual host configuration
echo "🔄 Updating virtual host configuration..."
cat > /etc/apache2/sites-available/sirion.k38.com.conf << 'EOF'
<VirtualHost *:80>
    ServerName sirion.k38.com
    ServerAlias www.k38.com

    # Logging
    ErrorLog ${APACHE_LOG_DIR}/sirion-error.log
    CustomLog ${APACHE_LOG_DIR}/sirion-access.log combined

    # Basic Auth for /admin
    <Location "/admin">
        AuthType Basic
        AuthName "Restricted Area"
        AuthUserFile /etc/apache2/.htpasswd
        Require valid-user
    </Location>

    # Proxy untuk /static → Lindon
    ProxyPass /static http://192.230.3.5/
    ProxyPassReverse /static http://192.230.3.5/

    # Proxy untuk /app → Vingilot
    ProxyPass /app http://192.230.3.6/
    ProxyPassReverse /app http://192.230.3.6/

    # Teruskan header penting
    RequestHeader set Host %{HTTP_HOST}s
    RequestHeader set X-Real-IP %{REMOTE_ADDR}s
</VirtualHost>
EOF
echo "✅ Virtual host updated with Basic Auth"

# Step 5: Enable modules
echo "🔄 Enabling Apache modules..."
a2enmod auth_basic proxy proxy_http headers rewrite
echo "✅ Modules enabled"

# Step 6: Restart Apache
echo "🔄 Restarting Apache..."
apache2ctl restart
echo "✅ Apache restarted"

echo "🎉 Basic Auth setup completed!"

#Vingilot

echo "🔄 Creating /admin page on Vingilot backend..."

# Step 1: Create admin directory and page
mkdir -p /var/www/app.k38.com/admin

# Step 2: Create admin index page
cat > /var/www/app.k38.com/admin/index.php << 'EOF'
<?php
echo "<h1>Admin Area - K38</h1>";
echo "<p>Selamat! Anda berhasil mengakses area admin.</p>";
echo "<p>IP Anda: " . $_SERVER['REMOTE_ADDR'] . "</p>";
echo '<a href="/">Kembali ke Beranda</a>';
?>
EOF

echo "✅ Admin page created at /var/www/app.k38.com/admin/index.php"

# Step 3: Set proper permissions
chown -R www-data:www-data /var/www/app.k38.com
echo "✅ Permissions set"

echo "🎉 Admin backend setup completed!"

Di Elrond (Client Penguji)
Tes koneksi:
ping www.k38.com
Harus reply dari 192.230.3.2.

Tes tanpa login:
curl -I http://www.k38.com/admin

Hasil harus:
HTTP/1.1 401 Unauthorized

Tes dengan login:
curl -u admin:ainur -I http://www.k38.com/admin/

Hasil harus:
HTTP/1.1 200 OK

Kalau muncul:
HTTP/1.1 404 Not Found
Berarti Basic Auth berfungsi, tapi file /admin di backend belum ada (pastikan langkah Vingilot sudah kamu buat).

Kalau muncul:

Copy code
HTTP/1.1 301 Moved Permanently

