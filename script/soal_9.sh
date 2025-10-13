#Tirion 
#!/bin/bash

echo "🔄 Configuring DNS for static.k38.com on Tirion..."

# Step 1: Update zone file with static record
cat > /etc/bind/zones/db.k38.com << 'EOF'
$TTL 604800
@   IN  SOA ns1.k38.com. root.ns1.k38.com. (
        2025101201  ; Serial
        604800      ; Refresh
        86400       ; Retry
        2419200     ; Expire
        604800 )    ; Negative Cache TTL

; Nameserver
@       IN  NS  ns1.k38.com.
@       IN  NS  ns2.k38.com.

; A record utama
ns1     IN  A   192.230.3.3
ns2     IN  A   192.230.3.4
sirion  IN  A   192.230.3.2
lindon  IN  A   192.230.3.5
vingilot IN A   192.230.3.6

; Record untuk web statis
static  IN  A   192.230.3.5
EOF
echo "✅ Updated zone file with static record"

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
dig static.k38.com @192.230.3.3 +short

echo "🎉 DNS configuration for static.k38.com completed!"

#Lindon

echo "🔄 Setting up static web server on Lindon..."

# Step 1: Configure DNS resolver
cat > /etc/resolv.conf << EOF
nameserver 192.230.3.3
nameserver 192.230.3.4
nameserver 8.8.8.8
nameserver 1.1.1.1
EOF
echo "✅ Updated resolv.conf"

# Step 2: Test internet connectivity
echo "🔍 Testing internet connectivity..."
ping -c 3 google.com

# Step 3: Update and install Apache
echo "🔄 Updating packages and installing Apache..."
apt-get update
apt-get install -y apache2
echo "✅ Apache installed"

# Step 4: Create web directory structure
echo "🔄 Creating web directory structure..."
mkdir -p /var/www/static.k38.com/annals
echo "Ini file pertama" > /var/www/static.k38.com/annals/test1.txt
echo "Halo dari Lampion Lindon!" > /var/www/static.k38.com/annals/readme.txt
echo "✅ Created web directory and sample files"

# Step 5: Create virtual host configuration
cat > /etc/apache2/sites-available/static.k38.com.conf << 'EOF'
<VirtualHost *:80>
    ServerName static.k38.com
    DocumentRoot /var/www/static.k38.com

    <Directory /var/www/static.k38.com/annals>
        Options +Indexes
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/static_error.log
    CustomLog ${APACHE_LOG_DIR}/static_access.log combined
</VirtualHost>
EOF
echo "✅ Created virtual host configuration"

# Step 6: Enable site and modules
echo "🔄 Configuring Apache..."
a2dissite 000-default.conf
a2ensite static.k38.com.conf
a2enmod autoindex
echo "✅ Enabled site and modules"

# Step 7: Restart Apache
echo "🔄 Restarting Apache..."
apache2ctl restart
echo "✅ Apache restarted"

# Step 8: Verify configuration
echo "🔍 Verifying Apache configuration..."
apache2ctl -S

# Step 9: Test the website
echo "🔍 Testing static.k38.com..."
curl http://static.k38.com/annals/

echo "🎉 Static web server setup completed!"

#Verification

echo "🔍 Comprehensive Verification for Static Web Server..."

# Step 1: Test DNS resolution
echo "1. Testing DNS resolution..."
dig static.k38.com

# Step 2: Test web access via hostname
echo ""
echo "2. Testing web access via hostname..."
curl -I http://static.k38.com/annals/

# Step 3: Test autoindex functionality
echo ""
echo "3. Testing autoindex functionality..."
curl http://static.k38.com/annals/

# Step 4: Verify access is via hostname, not IP
echo ""
echo "4. Verifying hostname access (not IP)..."
echo "Testing via hostname:"
curl -s http://static.k38.com/annals/ | head -10
echo ""
echo "Testing via IP (should be different or fail):"
curl -s http://192.230.3.5/annals/ | head -10

echo "🎉 Verification completed!"
