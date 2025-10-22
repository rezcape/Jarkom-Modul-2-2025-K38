# ==============================================================================
# Skenario: Bangkit Setelah Reboot (Enable & Verifikasi Autostart)
# ==============================================================================

# --- Konfigurasi di ns1 & ns2 (Server DNS) ---
# [Jalankan di ns1 dan ns2]
systemctl enable bind9

# --- Konfigurasi di Sirion & Lindon (Server Web) ---
# [Jalankan di Sirion dan Lindon]
systemctl enable nginx

# --- Konfigurasi di Vingilot (Server Aplikasi) ---
# [Jalankan di Vingilot]
systemctl enable php-fpm

# ==============================================================================
# SIMULASI REBOOT SEMUA SERVER
# ==============================================================================

# [Jalankan di semua server: ns1, ns2, Sirion, Lindon, Vingilot]
echo "Bumi bergetar... semua server reboot."
reboot

# ==============================================================================
# VERIFIKASI SETELAH SEMUA BANGKIT KEMBALI
# ==============================================================================

# --- Verifikasi DNS di ns1 & ns2 ---
# [Jalankan dari mesin Client/Anda]
echo "Verifikasi ns1..."
dig @ns1.lindon.com lindon.com +short

echo "Verifikasi ns2..."
dig @ns2.lindon.com lindon.com +short

# --- Verifikasi Web Server di Sirion & Lindon ---
# [Jalankan dari mesin Client/Anda]
echo "Verifikasi Sirion..."
curl -s --head http://sirion.lindon.com | head -n 1

echo "Verifikasi Lindon..."
curl -s --head http://lindon.com | head -n 1

# --- Verifikasi PHP-FPM di Vingilot ---
# [Login ke Vingilot untuk cek status]
systemctl status php-fpm