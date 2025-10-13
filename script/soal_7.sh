#!/bin/bash

#Tirion

echo "🔄 Starting DNS Records setup on Tirion..."

# Step 1: Backup original zone file
cp /etc/bind/zones/db.k38.com /etc/bind/zones/db.k38.com.backup
echo "✅ Created backup of zone file"

# Step 2: Update zone file with new records
cat > /etc/bind/zones/db.k38.com << EOF
; Zone file for k38.com
\$TTL 604800
@   IN  SOA ns1.k38.com. admin.k38.com. (
        2025101202  ; Serial
        604800      ; Refresh
        86400       ; Retry
        2419200     ; Expire
        604800 )    ; Negative Cache TTL
;
@       IN  NS  ns1.k38.com.
@       IN  NS  ns2.k38.com.
ns1     IN  A   192.230.3.3
ns2     IN  A   192.230.3.4
@       IN  A   192.230.3.10

; === Host tambahan ===
sirion      IN  A   192.230.3.5
lindon      IN  A   192.230.3.6
vingilot    IN  A   192.230.3.7

; === Alias (CNAME) ===
www         IN  CNAME   sirion.k38.com.
static      IN  CNAME   lindon.k38.com.
app         IN  CNAME   vingilot.k38.com.
EOF
echo "✅ Updated zone file with new records"

# Step 3: Restart BIND
echo "🔄 Restarting BIND service..."
pkill named
named -4 -u bind -c /etc/bind/named.conf
echo "✅ BIND restarted"

echo "🎉 DNS Records setup completed!"

#Valmar
echo "🔄 Starting DNS Slave update on Valmar..."

# Step 1: Remove old zone file to force fresh transfer
rm -f /var/lib/bind/db.k38.com
echo "✅ Removed old zone file"

# Step 2: Restart BIND to trigger zone transfer
echo "🔄 Restarting BIND for zone transfer..."
pkill named
named -4 -u bind -c /etc/bind/named.conf
echo "✅ BIND restarted"

# Step 3: Wait for zone transfer
echo "🔄 Waiting for zone transfer..."
sleep 5

echo "🎉 DNS Slave update completed!"

#!/bin/bash

#Verification
echo "🔄 Configuring DNS resolver on client..."

# Step 1: Configure resolv.conf
cat > /etc/resolv.conf << EOF
nameserver 192.230.3.3
nameserver 192.230.3.4
search k38.com
EOF
echo "✅ Updated resolv.conf"

# Step 2: Test DNS resolution
echo "🔍 Testing DNS resolution..."

echo "1. Testing A records:"
echo "sirion.k38.com: $(dig +short sirion.k38.com)"
echo "lindon.k38.com: $(dig +short lindon.k38.com)"
echo "vingilot.k38.com: $(dig +short vingilot.k38.com)"

echo "2. Testing CNAME records:"
echo "www.k38.com: $(dig +short www.k38.com)"
echo "static.k38.com: $(dig +short static.k38.com)"
echo "app.k38.com: $(dig +short app.k38.com)"

echo "3. Testing reverse resolution:"
echo "sirion IP: $(dig +short sirion.k38.com) -> $(dig +short -x 192.230.3.5)"
echo "lindon IP: $(dig +short lindon.k38.com) -> $(dig +short -x 192.230.3.6)"
echo "vingilot IP: $(dig +short vingilot.k38.com) -> $(dig +short -x 192.230.3.7)"

echo "✅ DNS client configuration completed!"



