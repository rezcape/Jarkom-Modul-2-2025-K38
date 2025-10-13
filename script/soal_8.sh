#!/bin/bash

#Tirion
echo "🔄 Setting up Reverse DNS Master on Tirion..."

# Step 1: Create zone directory
mkdir -p /etc/bind/zones
echo "✅ Created zone directory"

# Step 2: Add reverse zone to named.conf.local
cat >> /etc/bind/named.conf.local << EOF
zone "3.230.192.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.192.230.3";
    allow-transfer { 192.230.3.4; };
};
EOF
echo "✅ Added reverse zone to named.conf.local"

# Step 3: Create reverse zone file
cat > /etc/bind/zones/db.192.230.3 << 'EOF'
$TTL 604800
@   IN  SOA ns1.k38.com. root.ns1.k38.com. (
        2025101201  ; Serial
        604800      ; Refresh
        86400       ; Retry
        2419200     ; Expire
        604800 )    ; Negative Cache TTL

@   IN  NS  ns1.k38.com.
@   IN  NS  ns2.k38.com.

2   IN  PTR  sirion.k38.com.
5   IN  PTR  lindon.k38.com.
6   IN  PTR  vingilot.k38.com.
EOF
echo "✅ Created reverse zone file"

# Step 4: Validate configuration
echo "🔍 Validating configuration..."
named-checkconf
named-checkzone 3.230.192.in-addr.arpa /etc/bind/zones/db.192.230.3

# Step 5: Restart BIND
echo "🔄 Restarting BIND service..."
pkill named
named -f &
echo "✅ BIND restarted"

echo "🎉 Reverse DNS Master setup completed!"

#Valmar
echo "🔄 Setting up Reverse DNS Slave on Valmar..."

# Step 1: Add reverse zone to named.conf.local
cat >> /etc/bind/named.conf.local << EOF
zone "3.230.192.in-addr.arpa" {
    type slave;
    masters { 192.230.3.3; };
    file "/var/lib/bind/db.192.230.3";
};
EOF
echo "✅ Added reverse zone to named.conf.local"

# Step 2: Set permissions for bind directory
mkdir -p /var/lib/bind
chown bind:bind /var/lib/bind
echo "✅ Set bind directory permissions"

# Step 3: Restart BIND
echo "🔄 Restarting BIND for zone transfer..."
pkill named
named -f &
echo "✅ BIND restarted"

# Step 4: Wait for zone transfer
echo "🔄 Waiting for zone transfer..."
sleep 5

# Step 5: Verify zone file was transferred
echo "🔍 Checking transferred zone file..."
ls -l /var/lib/bind/

echo "🎉 Reverse DNS Slave setup completed!"

#verification
echo "🔍 Testing Reverse DNS from client..."

# Step 1: Configure DNS resolver
cat > /etc/resolv.conf << EOF
nameserver 192.230.3.3
EOF
echo "✅ Updated resolv.conf"

# Step 2: Test reverse lookups
echo "🔄 Testing reverse DNS lookups..."

echo "Testing sirion (192.230.3.2):"
dig -x 192.230.3.2

echo ""
echo "Testing lindon (192.230.3.5):"
dig -x 192.230.3.5

echo ""
echo "Testing vingilot (192.230.3.6):"
dig -x 192.230.3.6

echo "🎉 Reverse DNS testing completed!"
