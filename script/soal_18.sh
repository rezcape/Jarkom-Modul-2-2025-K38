# ==============================================================================
# Skenario: Menambahkan Nama Alias Musuh (Melkor & Morgoth)
# ==============================================================================

# --- Tambahkan Record di Tirion (ns1) ---
nano /etc/bind/db.lindon.com

# --- Tambahkan dua baris berikut di akhir file zona ---
# (PENTING: Jangan lupa NAIKKAN nomor seri SOA di bagian atas file!)

; ... (record-record sebelumnya)

# --- Record Baru untuk Musuh ---
melkor  IN      TXT     "Morgoth (Melkor)"
morgoth IN      CNAME   melkor.lindon.com.

# --- Terapkan Perubahan di Tirion (ns1) ---
service bind9 restart

# ==============================================================================
# VERIFIKASI (di Client)
# ==============================================================================

# --- 1. Verifikasi query TXT langsung ke melkor.lindon.com ---
#    Hasil yang diharapkan: "Morgoth (Melkor)"
echo "Query TXT untuk melkor..."
dig melkor.lindon.com TXT +short

# --- 2. Verifikasi morgoth.lindon.com mengikuti aliasnya ---
#    Hasil yang diharapkan: Akan menampilkan CNAME ke melkor, lalu TXT record dari melkor.
echo "Query TXT untuk morgoth..."
dig morgoth.lindon.com TXT