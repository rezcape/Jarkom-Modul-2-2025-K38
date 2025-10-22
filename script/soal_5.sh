echo "eonwe" > /etc/hostname
hostname -F /etc/hostname

cat >> /etc/hosts << EOF
192.230.1.1     eonwe.K38.com eonwe
192.230.1.2     earendil.K38.com earendil
192.230.1.3     elwing.K38.com elwing
192.230.2.2     cirdan.K38.com cirdan
192.230.2.3     elrond.K38.com elrond
192.230.2.4     maglor.K38.com maglor
192.230.3.2     sirion.K38.com sirion
192.230.3.3     tirion.K38.com tirion ns1.K38.com
192.230.3.4     valmar.K38.com valmar ns2.K38.com
192.230.3.5     lindon.K38.com lindon
192.230.3.6     vingilot.K38.com vingilot
EOF

# Verifikasi
hostname
hostname -f

# --- Ulangi untuk node lain ---
# Di EARENDIL: echo "earendil" > /etc/hostname, dst...
# Di ELWING: echo "elwing" > /etc/hostname, dst...
# Di CIRDAN: echo "cirdan" > /etc/hostname, dst...
# Di ELROND: echo "elrond" > /etc/hostname, dst...
# Di MAGLOR: echo "maglor" > /etc/hostname, dst...
# Di SIRION: echo "sirion" > /etc/hostname, dst...
# Di TIRION: echo "tirion" > /etc/hostname, dst...
# Di VALMAR: echo "valmar" > /etc/hostname, dst...
# Di LINDON: echo "lindon" > /etc/hostname, dst...
# Di VINGILOT: echo "vingilot" > /etc/hostname, dst...

# ===============================================================
# STEP 2: INSTALL BIND9 DI TIRION (ns1 - Master DNS)
# ===============================================================

# Jalankan di TIRION saja
apt-get update
apt-get install bind9 bind9utils dnsutils -y

# ===============================================================
# STEP 3: KONFIGURASI NAMED.CONF.LOCAL DI TIRION
# ===============================================================

nano /etc/bind/named.conf.local

# Isi dengan:
# ---------------------------------------------------------------
zone "K38.com" {
    type master;
    file "/etc/bind/K38.com/K38.com";
    allow-transfer { 192.230.3.4; }; // IP Valmar (ns2)
};

zone "eonwe.com" {
    type master;
    file "/etc/bind/zones/eonwe.com";
};

zone "earendil.com" {
    type master;
    file "/etc/bind/zones/earendil.com";
};

zone "elwing.com" {
    type master;
    file "/etc/bind/zones/elwing.com";
};

zone "cirdan.com" {
    type master;
    file "/etc/bind/zones/cirdan.com";
};

zone "elrond.com" {
    type master;
    file "/etc/bind/zones/elrond.com";
};

zone "maglor.com" {
    type master;
    file "/etc/bind/zones/maglor.com";
};

zone "sirion.com" {
    type master;
    file "/etc/bind/zones/sirion.com";
};

zone "lindon.com" {
    type master;
    file "/etc/bind/zones/lindon.com";
};

zone "vingilot.com" {
    type master;
    file "/etc/bind/zones/vingilot.com";
};
# ---------------------------------------------------------------

# ===============================================================
# STEP 4: BUAT DIREKTORI ZONE FILES DI TIRION
# ===============================================================

mkdir -p /etc/bind/K38.com
mkdir -p /etc/bind/zones

# ===============================================================
# STEP 5: BUAT ZONE FILE UTAMA K38.com DI TIRION
# ===============================================================

nano /etc/bind/K38.com/K38.com

# Isi dengan:
# ---------------------------------------------------------------
$TTL    604800
@       IN      SOA     ns1.K38.com. root.K38.com. (
                      2025101301 ; Serial - NAIKKAN setiap edit!
                      604800     ; Refresh
                      86400      ; Retry
                      2419200    ; Expire
                      604800 )   ; Negative Cache TTL

; Name Servers
@       IN      NS      ns1.K38.com.
@       IN      NS      ns2.K38.com.

; A Records untuk Nameservers (PENGECUALIAN - tetap tirion & valmar)
ns1     IN      A       192.230.3.3   ; Tirion
ns2     IN      A       192.230.3.4   ; Valmar

; A Record domain utama
@       IN      A       192.230.3.2   ; Sirion

; Hostname Records untuk semua node
eonwe       IN      A       192.230.1.1
earendil    IN      A       192.230.1.2
elwing      IN      A       192.230.1.3
cirdan      IN      A       192.230.2.2
elrond      IN      A       192.230.2.3
maglor      IN      A       192.230.2.4
sirion      IN      A       192.230.3.2
lindon      IN      A       192.230.3.5
vingilot    IN      A       192.230.3.6
# ---------------------------------------------------------------

# ===============================================================
# STEP 6: BUAT ZONE FILE INDIVIDUAL DI TIRION
# ===============================================================

# --- EONWE.COM ---
nano /etc/bind/zones/eonwe.com

$TTL    604800
@       IN      SOA     ns1.K38.com. root.eonwe.com. (
                      2025101301
                      604800
                      86400
                      2419200
                      604800 )

@       IN      NS      ns1.K38.com.
@       IN      NS      ns2.K38.com.
@       IN      A       192.230.1.1
eru     IN      A       192.230.1.1
www     IN      A       192.230.1.1

# --- EARENDIL.COM ---
nano /etc/bind/zones/earendil.com

$TTL    604800
@       IN      SOA     ns1.K38.com. root.earendil.com. (
                      2025101301
                      604800
                      86400
                      2419200
                      604800 )

@       IN      NS      ns1.K38.com.
@       IN      NS      ns2.K38.com.
@       IN      A       192.230.1.2
eru     IN      A       192.230.1.2
www     IN      A       192.230.1.2

# --- ELWING.COM ---
nano /etc/bind/zones/elwing.com

$TTL    604800
@       IN      SOA     ns1.K38.com. root.elwing.com. (
                      2025101301
                      604800
                      86400
                      2419200
                      604800 )

@       IN      NS      ns1.K38.com.
@       IN      NS      ns2.K38.com.
@       IN      A       192.230.1.3
eru     IN      A       192.230.1.3
www     IN      A       192.230.1.3

# --- CIRDAN.COM ---
nano /etc/bind/zones/cirdan.com

$TTL    604800
@       IN      SOA     ns1.K38.com. root.cirdan.com. (
                      2025101301
                      604800
                      86400
                      2419200
                      604800 )

@       IN      NS      ns1.K38.com.
@       IN      NS      ns2.K38.com.
@       IN      A       192.230.2.2
eru     IN      A       192.230.2.2
www     IN      A       192.230.2.2

# --- ELROND.COM ---
nano /etc/bind/zones/elrond.com

$TTL    604800
@       IN      SOA     ns1.K38.com. root.elrond.com. (
                      2025101301
                      604800
                      86400
                      2419200
                      604800 )

@       IN      NS      ns1.K38.com.
@       IN      NS      ns2.K38.com.
@       IN      A       192.230.2.3
eru     IN      A       192.230.2.3
www     IN      A       192.230.2.3

# --- MAGLOR.COM ---
nano /etc/bind/zones/maglor.com

$TTL    604800
@       IN      SOA     ns1.K38.com. root.maglor.com. (
                      2025101301
                      604800
                      86400
                      2419200
                      604800 )

@       IN      NS      ns1.K38.com.
@       IN      NS      ns2.K38.com.
@       IN      A       192.230.2.4
eru     IN      A       192.230.2.4
www     IN      A       192.230.2.4

# --- SIRION.COM ---
nano /etc/bind/zones/sirion.com

$TTL    604800
@       IN      SOA     ns1.K38.com. root.sirion.com. (
                      2025101301
                      604800
                      86400
                      2419200
                      604800 )

@       IN      NS      ns1.K38.com.
@       IN      NS      ns2.K38.com.
@       IN      A       192.230.3.2
eru     IN      A       192.230.3.2
www     IN      A       192.230.3.2

# --- LINDON.COM ---
nano /etc/bind/zones/lindon.com

$TTL    604800
@       IN      SOA     ns1.K38.com. root.lindon.com. (
                      2025101301
                      604800
                      86400
                      2419200
                      604800 )

@       IN      NS      ns1.K38.com.
@       IN      NS      ns2.K38.com.
@       IN      A       192.230.3.5
eru     IN      A       192.230.3.5
www     IN      A       192.230.3.5

# --- VINGILOT.COM ---
nano /etc/bind/zones/vingilot.com

$TTL    604800
@       IN      SOA     ns1.K38.com. root.vingilot.com. (
                      2025101301
                      604800
                      86400
                      2419200
                      604800 )

@       IN      NS      ns1.K38.com.
@       IN      NS      ns2.K38.com.
@       IN      A       192.230.3.6
eru     IN      A       192.230.3.6
www     IN      A       192.230.3.6

# ===============================================================
# STEP 7: CEK KONFIGURASI & RESTART BIND9 DI TIRION
# ===============================================================

# Cek syntax konfigurasi
named-checkconf

# Cek zone files
named-checkzone K38.com /etc/bind/K38.com/K38.com
named-checkzone eonwe.com /etc/bind/zones/eonwe.com
named-checkzone earendil.com /etc/bind/zones/earendil.com
# ... (cek semua zone)

# Restart BIND9

#kalau belum ada
ln -s /etc/init.d/named /etc/init.d/bind9
#restart
service bind9 restart

# Cek status
service bind9 status

# ===============================================================
# STEP 8: SETUP BIND9 DI VALMAR (ns2 - Slave DNS)
# ===============================================================

# Jalankan di VALMAR
apt-get update
apt-get install bind9 bind9utils dnsutils -y

# Edit konfigurasi
nano /etc/bind/named.conf.local

# Isi dengan:
# ---------------------------------------------------------------
zone "K38.com" {
    type slave;
    masters { 192.230.3.3; }; // IP Tirion (ns1)
    file "/var/cache/bind/K38.com";
};
# ---------------------------------------------------------------

# Restart BIND9
#kalau belum ada
ln -s /etc/init.d/named /etc/init.d/bind9
service bind9 restart
service bind9 status

# ===============================================================
# STEP 9: SETUP RESOLV.CONF DI SEMUA CLIENT
# ===============================================================

# Jalankan di semua node (kecuali Tirion & Valmar)
nano /etc/resolv.conf

# Isi dengan:
# ---------------------------------------------------------------
nameserver 192.230.3.3  # ns1 (Tirion)
nameserver 192.230.3.4  # ns2 (Valmar)
search K38.com
# ---------------------------------------------------------------

# ===============================================================
# STEP 10: TESTING
# ===============================================================

# Test dari client mana saja

# Test 1: Hostname resolution
hostname
hostname -f

# Test 2: Ping hostname di K38.com
ping -c 2 sirion.K38.com
ping -c 2 eonwe.K38.com
ping -c 2 earendil.K38.com

# Test 3: Ping domain individual
ping -c 2 eonwe.com
ping -c 2 eru.eonwe.com
ping -c 2 www.earendil.com

# Test 4: Dig queries
dig K38.com
dig sirion.K38.com
dig eonwe.com
dig eru.eonwe.com

# Test 5: Nslookup
nslookup sirion.K38.com
nslookup eru.eonwe.com
nslookup eonwe.com ns1.K38.com

# Test 6: Cek nameserver
dig NS K38.com
dig @192.230.3.3 K38.com  # Query ke ns1
dig @192.230.3.4 K38.com  # Query ke ns2