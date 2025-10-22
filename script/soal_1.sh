
#Eonwe
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 192.230.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 192.230.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 192.230.3.1
	netmask 255.255.255.0

#Earendil
auto eth0
iface eth0 inet static
	address 192.230.1.2
	netmask 255.255.255.0
	gateway 192.230.1.1

#Elwing
auto eth0
iface eth0 inet static
	address 10.15.43.32.1.3
	netmask 255.255.255.0
	gateway 10.15.43.32.1.1

#Cirdan
auto eth0
iface eth0 inet static
	address 192.230.2.2
	netmask 255.255.255.0
	gateway 192.230.2.1

#Elrond
auto eth0
iface eth0 inet static
	address 192.230.2.3
	netmask 255.255.255.0
	gateway 192.230.2.1

#Maglor
auto eth0
iface eth0 inet static
	address 192.230.2.4
	netmask 255.255.255.0
	gateway 192.230.2.1

#Sirion
auto eth0
iface eth0 inet static
	address 192.230.3.2
	netmask 255.255.255.0
	gateway 192.230.3.1

#Tirion
auto eth0
iface eth0 inet static
	address 192.230.4.2
	netmask 255.255.255.0
	gateway 192.230.4.1

#Valmar
auto eth0
iface eth0 inet static
	address 192.230.4.3
	netmask 255.255.255.0
	gateway 192.230.4.1

#Lindon
auto eth0
iface eth0 inet static
	address 192.230.4.4
	netmask 255.255.255.0
	gateway 192.230.4.1

#Vingilot
auto eth0
iface eth0 inet static
	address 192.230.4.5
	netmask 255.255.255.0
    gateway 192.230.4.1