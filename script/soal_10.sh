#Tirion

echo "🔄 Configuring DNS for app.k38.com on Tirion..."

# Step 1: Update zone file with app record
cat >> /etc/bind/zones/db.k38.com << 'EOF'
; Record untuk web dinamis
app     IN  A   192.230.3.6
EOF
echo "✅ Added app record to zone file"

# Step 2: Validate zone file
echo "🔍 Validating zone file..."
named-checkzone k38.com /etc/bind/zones/db.k38.com

# Step 3: Restart BIND
echo "🔄 Restarting BIND..."
pkill named
named -f &
echo "✅ BIND restarted"

# Step 4: Verify DNS resolution
echo "🔍 Verifying DNS resolution..."
dig app.k38.com @192.230.3.3 +short

echo "🎉 DNS configuration for app.k38.com completed!"

#Vingilot

echo "🔄 Setting up dynamic web server on Vingilot..."

# Step 1: Configure DNS resolver
cat > /etc/resolv.conf << EOF
nameserver 192.230.3.3
nameserver 192.230.3.4
nameserver 8.8.8.8
EOF
echo "✅ Updated resolv.conf"

# Step 2: Update and install packages
echo "🔄 Updating packages and installing Apache + PHP-FPM..."
apt-get update
apt-get install -y apache2 php8.4-fpm
echo "✅ Apache and PHP-FPM installed"

# Step 3: Enable modules and configuration
echo "🔄 Configuring Apache modules..."
a2enmod proxy_fcgi setenvif rewrite
a2enconf php8.4-fpm
apache2ctl restart
echo "✅ Apache modules configured"

# Step 4: Start PHP-FPM
echo "🔄 Starting PHP-FPM..."
php-fpm8.4 -D
echo "✅ PHP-FPM started"

# Step 5: Create web directory structure
echo "🔄 Creating web directory structure..."
mkdir -p /var/www/app.k38.com
cd /var/www/app.k38.com

# Step 6: Create PHP files
cat > index.php << 'EOF'
<?php
echo "<h1>Selamat datang di App K38</h1>";
echo "<p>Ini adalah beranda aplikasi dinamis</p>";
echo '<a href="/about">Pergi ke About</a>';
?>
EOF

cat > about.php << 'EOF'
<?php
echo "<h1>Ini halaman About App K38</h1>";
echo "<p>Halaman about yang diakses tanpa .php</p>";
echo '<a href="/">Kembali ke Beranda</a>';
?>
EOF
echo "✅ Created PHP files"

# Step 7: Create virtual host configuration
cat > /etc/apache2/sites-available/app.k38.com.conf << 'EOF'
<VirtualHost *:80>
    ServerName app.k38.com
    DocumentRoot /var/www/app.k38.com

    <Directory /var/www/app.k38.com>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/app_error.log
    CustomLog ${APACHE_LOG_DIR}/app_access.log combined
</VirtualHost>
EOF
echo "✅ Created virtual host configuration"

# Step 8: Create .htaccess for URL rewriting
cat > /var/www/app.k38.com/.htaccess << 'EOF'
RewriteEngine On
RewriteRule ^about$ about.php [L]
EOF
echo "✅ Created .htaccess for URL rewriting"

# Step 9: Configure Apache ServerName
echo "ServerName localhost" >> /etc/apache2/apache2.conf
echo "✅ Configured Apache ServerName"

# Step 10: Enable site and disable default
echo "🔄 Configuring Apache sites..."
a2dissite 000-default.conf
a2ensite app.k38.com.conf
a2enmod rewrite
echo "✅ Site configuration completed"

# Step 11: Restart Apache
echo "🔄 Restarting Apache..."
apache2ctl restart
echo "✅ Apache restarted"

# Step 12: Verify configuration
echo "🔍 Verifying Apache configuration..."
apache2ctl -S

# Step 13: Test the website
echo "🔍 Testing app.k38.com..."
echo "Testing homepage:"
curl -s http://app.k38.com/ | head -5
echo ""
echo "Testing about page (without .php):"
curl -s http://app.k38.com/about | head -5

echo "🎉 Dynamic web server setup completed!"

#Veification
curl http://app.k38.com/
curl http://app.k38.com/about

✅ Output:
<h1>Selamat datang di App K38</h1>
<h1>Ini halaman About App K38</h1>


