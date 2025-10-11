
#Instalation
apt-get update
apt-get install bind9 -y

#Mapping named to bind9
ln -s /etc/init.d/named /etc/init.d/bind9

#Domain Making
nano /etc/bind/named.conf.local

#Domain Configuration
zone "K38.com" {
	type master;
	file "/etc/bind/ns1/ns1.K38.com";
};

#Make folder inside /etc/bind
mkdir /etc/bind/ns1

