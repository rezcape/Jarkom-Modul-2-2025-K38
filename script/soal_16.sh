# ==============================================================================
# Skenario: Perubahan IP lindon.com
# ==============================================================================

# --- Verifikasi Kondisi Awal (di Client) ---
dig lindon.com A +short
dig static.com A +short

# --- Ubah Konfigurasi di Tirion (ns1) ---
nano /etc/bind/db.lindon.com

# --- Konten db.lindon.com SETELAH diubah ---
# (Pastikan NAIKKAN SERIAL dan ubah A Record dengan TTL 30s)
$TTL    86400
@       IN      SOA     ns1.lindon.com. root.lindon.com. (
                        2025101302      ; Serial NAIK!
                        3600            ; Refresh
                        1800            ; Retry
                        604800          ; Expire
                        86400 )         ; Negative Cache TTL
;
@       IN      NS      ns1.lindon.com.
@       IN      NS      ns2.lindon.com.
ns1     IN      A       192.168.1.1
ns2     IN      A       192.168.1.2

# --- Record yang diubah ---
@       30      IN      A       192.168.1.25    ; IP BARU + TTL 30 detik
static  IN      CNAME   lindon.com.

# --- Terapkan Perubahan di Tirion (ns1) ---
service bind9 restart

# ==============================================================================
# TAHAPAN VERIFIKASI (di Client)
# ==============================================================================

# --- 1. Sesaat setelah perubahan (masih dapat IP lama dari cache) ---
echo "Verifikasi sebelum TTL kedaluwarsa (masih IP lama)..."
dig lindon.com A +short
dig static.com A +short

# --- Menunggu Cache Kedaluwarsa ---
echo "Menunggu 30 detik..."
sleep 30

# --- 2. Setelah TTL kedaluwarsa (dapat IP baru) ---
echo "Verifikasi setelah TTL kedaluwarsa (sudah IP baru)..."
dig lindon.com A +short
dig static.com A +short

# --- 3. Cek Sinkronisasi di Valmar (ns2) ---
echo "Verifikasi langsung ke server sekunder (Valmar)..."
dig @ns2.lindon.com lindon.com A +short