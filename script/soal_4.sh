
#Instalation on Tirion
apt-get update
apt-get install bind9 -y

#Mapping named to bind9
ln -s /etc/init.d/named /etc/init.d/bind9

#Domain Making
nano /etc/bind/named.conf.local

#Domain Configuration
zone "K38.com" {
	type master;
	file "/etc/bind/K38.com/ns1.K38.com";
};

#Make folder inside /etc/bind
mkdir /etc/bind/K38.com


#Edit the /etc/bind/k38.com/ns1.K38.com
nano /etc/bind/K38.com/ns1.K38.com

#Fill the ns1.K38.com with the following configuration(using zone template on github)
$TTL    604800
@       IN      SOA     ns1.K38.com. root.K38.com. (
                      2025100401 ; Serial
                      604800     ; Refresh
                      86400      ; Retry
                      2419200    ; Expire
                      604800 )   ; Negative Cache TTL
;
; --- Daftar Name Server Resmi ---
@       IN      NS      ns1.K38.com.
@       IN      NS      ns2.K38.com.

; --- A Record untuk Name Server
ns1     IN      A       192.230.3.3   ; IP Tirion
ns2     IN      A       192.230.3.4   ; IP Valmar

; --- A Record untuk Domain Utama 
@       IN      A       192.230.3.1   ; IP Sirion (Gerbang Depan)


#restart bind9
service bind9 restart

#Setting nameserver 
nano /etc/resolv.conf

#Fill the resolv.conf with the following configuration
nameserver 192.230.3.3
nameserver 192.230.3.4

#Testing
ping K38.com -c 5

#Make DNS Slave on Valmar
nano /etc/bind/named.conf.local

#Add the following configuration to the named.conf.local on Tirion
zone "K38.com" {
    type master;
    notify yes;
    also-notify { 192.230.3.4; }; 
    allow-transfer { 192.230.3.4; }; 
    file "/etc/bind/K38.com/ns1.K38.com";
};

#Restart bind9
service bind9 restart

#Configure Valmar as DNS Slave
apt-get update
apt-get install bind9 -y

nano /etc/bind/named.conf.local

zone "K38.com" {
    type slave;
    masters { 192.230.3.3; }; 
    file "/etc/bind/K38.com/ns1.K38.com";
};

ln -s /etc/init.d/named /etc/init.d/bind9

service bind9 restart

#Testing on client
ping K38.com -c 5

#or

dig k38.com 