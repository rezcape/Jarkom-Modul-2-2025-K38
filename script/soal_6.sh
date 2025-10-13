#!/bin/bash

echo "🔄 Starting DNS Master setup on Tirion..."

# Step 1: Create zone directory
mkdir -p /etc/bind/zones
echo "✅ Created zone directory"

# Step 2: Create zone file
cat > /etc/bind/zones/db.k38.com << EOF
; Zone file for k38.com
\$TTL    604800
@       IN      SOA     ns1.k38.com. admin.k38.com. (
                        2025101201  ; Serial
                        604800      ; Refresh
                        86400       ; Retry
                        2419200     ; Expire
                        604800 )    ; Negative Cache TTL
;
@       IN      NS      ns1.k38.com.
@       IN      NS      ns2.k38.com.
ns1     IN      A       192.230.3.3
ns2     IN      A       192.230.3.4
@       IN      A       192.230.3.10
www     IN      CNAME   k38.com.
EOF
echo "✅ Created zone file"

# Step 3: Configure BIND
cat >> /etc/bind/named.conf.local << EOF
zone "k38.com" {
    type master;
    file "/etc/bind/zones/db.k38.com";
    allow-transfer { 192.230.3.4; };
    also-notify { 192.230.3.4; };
};
EOF
echo "✅ Updated named.conf.local"

# Step 4: Restart BIND
echo "🔄 Restarting BIND service..."
pkill named
named -4 -u bind -c /etc/bind/named.conf
echo "✅ BIND restarted"

echo "DNS Master setup completed!"

#!/bin/bash

echo "🔄 Starting DNS Slave setup on Valmar..."

# Step 1: Create and set permissions for bind directory
mkdir -p /var/lib/bind
chown bind:bind /var/lib/bind
echo "✅ Created bind directory"

# Step 2: Configure slave zone
cat >> /etc/bind/named.conf.local << EOF
zone "k38.com" {
    type slave;
    masters { 192.230.3.3; };
    file "/var/lib/bind/db.k38.com";
};
EOF
echo "✅ Updated named.conf.local"

# Step 3: Restart BIND
echo "🔄 Restarting BIND service..."
pkill named
named -4 -u bind -c /etc/bind/named.conf
echo "✅ BIND restarted"

echo "🎉 DNS Slave setup completed!"


Di Tirion:
dig @192.230.3.3 k38.com SOA

Di Valmar:
dig @192.230.3.4 k38.com SOA

Pastikan angka Serial (misal 2025101201) sama di keduanya
Artinya Valmar udah sinkron & update otomatis dari Tirion
