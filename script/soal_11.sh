#Tirion 

#!/bin/bash

echo "🔄 Configuring DNS for reverse proxy on Tirion..."

# Step 1: Update zone file with www CNAME
cat > /etc/bind/zones/db.k38.com << 'EOF'
$TTL 604800
@   IN  SOA ns1.k38.com. root.ns1.k38.com. (
        2025101204  ; Serial
        604800      ; Refresh
        86400       ; Retry
        2419200     ; Expire
        604800 )    ; Negative Cache TTL

; Nameservers
@       IN  NS  ns1.k38.com.
@       IN  NS  ns2.k38.com.

; A records
ns1       IN  A   192.230.3.3
ns2       IN  A   192.230.3.4
sirion    IN  A   192.230.3.2
lindon    IN  A   192.230.3.5
vingilot  IN  A   192.230.3.6

; Web services
static    IN  A   192.230.3.5
app       IN  A   192.230.3.6
www       IN  CNAME sirion.k38.com.
EOF
echo "✅ Updated zone file with www CNAME"

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
echo "www.k38.com: $(dig +short www.k38.com)"
echo "sirion.k38.com: $(dig +short sirion.k38.com)"

echo "🎉 DNS configuration for reverse proxy completed!"

#Sirion

#!/bin/bash

echo "🔄 Setting up reverse proxy on Sirion..."

# Step 1: Configure DNS resolver
cat > /etc/resolv.conf << EOF
nameserver 192.230.3.3
nameserver 192.230.3.4
nameserver 8.8.8.8
nameserver 1.1.1.1
EOF
echo "✅ Updated resolv.conf"

# Step 2: Update and install Apache
echo "🔄 Installing and configuring Apache..."
apt-get update
apt-get install -y apache2
echo "✅ Apache installed"

# Step 3: Enable required modules
echo "🔄 Enabling Apache modules..."
a2enmod proxy proxy_http headers rewrite
echo "✅ Apache modules enabled"

# Step 4: Create virtual host configuration
cat > /etc/apache2/sites-available/sirion.k38.com.conf << 'EOF'
<VirtualHost *:80>
    ServerName sirion.k38.com
    ServerAlias www.k38.com

    # Logging
    ErrorLog ${APACHE_LOG_DIR}/sirion-error.log
    CustomLog ${APACHE_LOG_DIR}/sirion-access.log combined

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
echo "✅ Created reverse proxy virtual host"

# Step 5: Configure Apache ServerName
echo "ServerName localhost" >> /etc/apache2/apache2.conf
echo "✅ Configured Apache ServerName"

# Step 6: Enable site and disable default
echo "🔄 Configuring Apache sites..."
a2dissite 000-default.conf
a2ensite sirion.k38.com.conf
echo "✅ Site configuration completed"

# Step 7: Restart Apache
echo "🔄 Restarting Apache..."
apache2ctl restart
echo "✅ Apache restarted"

# Step 8: Test configuration
echo "🔍 Testing reverse proxy configuration..."
echo "Testing DNS resolution:"
nslookup www.k38.com
nslookup sirion.k38.com

echo "Testing reverse proxy paths:"
echo "/static -> Lindon:"
curl -s http://www.k38.com/static/annals/ | head -10
echo ""
echo "/app -> Vingilot:"
curl -s http://www.k38.com/app/ | head -5

echo "🎉 Reverse proxy setup completed!"

#Verification
Tes DNS
dig www.k38.com @192.230.3.3

Harus balik ke 192.230.3.2.
Tes proxy
curl http://www.k38.com/static/annals/
curl http://www.k38.com/app/

✅ Output yang benar:
# Dari /static → Lindon:
Index of /annals
readme.txt
test1.txt

# Dari /app → Vingilot:
<h1>Selamat datang di App K38</h1>

