#setup the hostname system (on every machine)
hostnamectl set-hostname earendil #example

#optional: add to /etc/hosts (on every machine)
nano /etc/hosts

#verify the hostname (on every machine)
hostname

#add nameserver (on master server only)
nano /etc/bind/K38.com/ns1.K38.com #on tirion

#Fill the zone file with the following configuration
$TTL    604800
@       IN      SOA     ns1.K38.com. root.K38.com. (
                      2025100402 ; 🚨 NAIKKAN NOMOR INI! (misal dari 01)
                      604800     ; Refresh
                      86400      ; Retry
                      2419200    ; Expire
                      604800 )   ; Negative Cache TTL
;
; Name Servers & Main Domain A Record (dari soal #4)
@       IN      NS      ns1.K38.com.
@       IN      NS      ns2.K38.com.
ns1     IN      A       192.230.3.3   ; IP Tirion
ns2     IN      A       192.230.3.4   ; IP Valmar
@       IN      A       192.230.3.1   ; IP Sirion

; --- TAMBAHKAN SEMUA RECORD DI BAWAH INI ---
; Hostname Records for all characters
eonwe       IN      A       192.230.3.254 ; IP Eonwe
earendil    IN      A       192.230.1.2   ; IP Earendil
elwing      IN      A       192.230.1.3   ; IP Elwing
cirdan      IN      A       192.230.2.2   ; IP Cirdan
elrond      IN      A       192.230.2.3   ; IP Elrond
maglor      IN      A       192.230.2.4   ; IP Maglor
sirion      IN      A       192.230.3.1   ; IP Sirion
lindon      IN      A       192.230.3.5   ; IP Lindon
vingilot    IN      A       192.230.3.6   ; IP Vingilot

#increase th the serial number each time you make changes to this file!
#restart bind9 (on master server only)
service bind9 restart

#Testing on client
ping sirion.K38.com 
#or
dig sirion.K38.com