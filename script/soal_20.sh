# ==============================================================================
# Skenario: Kisah Ditutup di Beranda Sirion
# ==============================================================================

# --- Konfigurasi Beranda di Sirion ---
# [Jalankan di server Sirion]
# Buat atau timpa file index.html utama.
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>War of Wrath: Lindon bertahan</title>
</head>
<body>
    <h1>War of Wrath: Lindon bertahan</h1>
    <p>Kisah ditutup di sini, namun perjalanan baru menanti.</p>
    <ul>
        <li><a href="/app">Masuk ke Aplikasi Inti (/app)</a></li>
        <li><a href="/static">Lihat Aset Statis (/static)</a></li>
    </ul>
</body>
</html>
EOF

# ==============================================================================
# VERIFIKASI DARI KLIEN
# ==============================================================================

# [Jalankan di mesin Client]

# --- 1. Membuka halaman depan menggunakan hostname ---
echo "Membuka beranda www.lindon.com..."
# Kita gunakan curl dan grep untuk memastikan judulnya benar
curl -s http://www.lindon.com | grep "<title>"

# --- 2. Menelusuri tautan /app ---
echo "Menguji tautan ke /app..."
# -I hanya mengambil header, HTTP/1.1 200 OK berarti berhasil
curl -I http://www.lindon.com/app

# --- 3. Menelusuri tautan /static ---
echo "Menguji tautan ke /static..."
curl -I http://www.lindon.com/static