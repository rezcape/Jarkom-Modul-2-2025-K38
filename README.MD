# 📄 Laporan Komdat Jarkom Modul 2 — 2025

## 👥 Anggota Kelompok

| Nama                     | NRP        |
| ------------------------ | ---------- |
| Ahmad Syauqi Reza        | 5027241085 |
| Putri Joselina Silitonga | 5027241116 |

## Deskripsi Laporan 📝

---

# Soal 1

Pada praktikum ini digunakan **GNS3 Web UI** dengan host IP `192.230.1.1`.  
Dibuat sebuah project dengan topologi sebagai berikut:

- Eonwe = panglima/gerbang (router)
- Earendil, Elwing = klien Barat
- Cirdan, Elrond, Maglor = klien Timur
- Sirion = gerbang pelabuhan (reverse proxy)
- Tirion = penjaga nama utama (ns1)
- Valmar = penjaga nama bayangan (ns2)
- Lindon = pelabuhan web statis
- Vingilot = kapal web dinamis
- **Eonwe** merentangkan tiga jalur: Barat untuk **Earendil** dan **Elwing**, Timur untuk **Círdan**, **Elrond**, **Maglor**, serta pelabuhan DMZ bagi **Sirion**, **Tirion**, **Valmar**, **Lindon**, **Vingilot**.
- Router terhubung ke **internet** melalui **NAT1**.
- Router juga terhubung ke **dua switch**.
- Masing-masing switch kemudian menghubungkan **dua client**.

Struktur topologi ini dapat dilihat pada gambar berikut:  
![Image_1](asset\1.png)

# Soal 2

Kita diminta untuk mengkonfigurasi **Eonwe** agar bisa berfungsi seperti router(contoh router wifi), semua perangkat di sekitarnya bisa mengakses internet menggunakan satu koneksi yang sama. Proses ini disebut NAT atau Network Address Translation.

Buat perintah untuk mengizinkan semua jaringan internal untuk "nebeng" ke"" koneksi **Eanwe** ke internet seperti kode berikut :

```
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.230.0.0/16
```

Sehingga ketika menguji melalui salah satu klien internal, seperti **Cirdan**, maka ketika dilakukan ping 8.8.8.8 (ping google) akan mendapat respons.
![image_2](asset\2.png)

# Soal 3

Pada soal ini, kita diminta untuk memverifikasi lagi bahwa semua konfigurasi sudah benar dengan melakukan ping dari klien ke server di jaringan DMZ. Berikut hasil ping dari **Earendil**(Klien Barat) ke **Elrond**(Klien Timur).

![image_3.1](asset\3.png)

Kemudian agar semua perangkat bisa menginstall paket atau mengakses internet via nama domain sejak awal, kita diminta untuk menjalankan perintah seperti berikut:

```
echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
