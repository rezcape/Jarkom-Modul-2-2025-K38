# ==============================================================================
# Skenario: Perluasan Pelabuhan (Menambahkan CNAME havens)
# ==============================================================================

# --- Tambahkan Record di Tirion (ns1) ---
nano /etc/bind/db.lindon.com

# --- Tambahkan baris berikut di akhir file zona ---
# (PENTING: Jangan lupa NAIKKAN nomor seri SOA di bagian atas file!)

; ... (record-record sebelumnya)

# --- Record Baru untuk Pelabuhan ---
havens  IN      CNAME   www.lindon.com.

# --- Terapkan Perubahan di Tirion (ns1) ---
service bind9 restart

# ==============================================================================
# VERIFIKASI DARI DUA KLIEN BERBEDA
# ==============================================================================

# --- Di Client 1 ---
echo "Verifikasi dari Client 1..."

# Cek resolusi DNS
dig havens.lindon.com +short

# Cek akses layanan web (akan menampilkan header HTTP dari www.lindon.com)
curl -I http://havens.lindon.com


# --- Di Client 2 ---
echo "Verifikasi dari Client 2..."

# Cek resolusi DNS
ping -c 3 havens.lindon.com

# Cek akses layanan web
curl -I http://havens.lindon.com