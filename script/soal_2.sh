#Instalation
apt-get update
apt-get install iptables -y

#Enable IP Forwarding
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.230.0.0/16
