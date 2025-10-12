
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

#Make zone.template inside /etc/bind/ directory.
nano /etc/bind/zone.template

#Fill the zone.template with the following configuration
$TTL    604800          ; Waktu cache default (detik)
@       IN      SOA     localhost. root.localhost. (
                        2025100401 ; Serial (format YYYYMMDDXX)
                        604800     ; Refresh (1 minggu)
                        86400      ; Retry (1 hari)
                        2419200    ; Expire (4 minggu)
                        604800 )   ; Negative Cache TTL
;

@       IN      NS      localhost.
@       IN      A       127.0.0.1

#Copy zone.template to /etc/bind/k38.com/ns1.K38.com
cp /etc/bind/zone.template /etc/bind/K38.com/ns1.K38.com

#Edit the /etc/bind/k38.com/ns1.K38.com
nano /etc/bind/K38.com/ns1.K38.com

#Fill the ns1.K38.com with the following configuration
$TTL    604800          ; Waktu cache default (detik)
@       IN      SOA     ns1.K38.com. root.ns1.K38.com. (
                        2025100401 ; Serial (format YYYYMMDDXX)
                        604800     ; Refresh (1 minggu)
                        86400      ; Retry (1 hari)
                        2419200    ; Expire (4 minggu)
                        604800 )   ; Negative Cache TTL
;

@       IN      NS      ns1.K38.com.
@       IN      NS      ns2.K38.com.

@       IN      A       192.230.3.3
@       IN      A       192.230.3.4


#restart bind9
service bind9 restart

#Setting nameserver 
nano /etc/resolv.conf

#Fill the resolv.conf with the following configuration
nameserver 192.230.3.3
nameserver 192.230.3.4

#Testing
ping K38.com -c 5

#Make DNS Slave
nano /etc/bind/named.conf.local

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
service bind9 stop

ping K38.com -c 5