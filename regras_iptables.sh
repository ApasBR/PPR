#!/bin/bash
clear

# Limpando tabelas do iptables:

iptables -F
iptables -t nat -F

sleep 3

# Abilitando regras  para acceso a internet do Cliente e do Firewall:

echo 1 > /proc/sys/net/ipv4/ip_forward

iptables -t nat -I POSTROUTING -s 192.168.1.0/24 -j MASQUERADE

iptables -t nat -I POSTROUTING -s 172.16.1.1/32 -j MASQUERADE

# Dropando tudo na tabela FILTER:

iptables -t filter -I INPUT -j DROP
iptables -t filter -I FORWARD -j DROP
iptables -t filter -I OUTPUT -j DROP


# Abilitando todas as novas conexões ao cliente a internet:

iptables -t filter -I FORWARD -i eth0 -o eth2 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT


iptables -t filter -I FORWARD -i eth2 -o eth0  -m state --state ESTABLISHED,RELATED -j ACCEPT

# Acesso ao ftp, mas ele não accessa ninguém:


iptables -t filter -I FORWARD -i eth2 -o eth1 -p tcp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT


iptables -t filter -I FORWARD -i eth1 -o eth2  -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT


iptables -t filter -I FORWARD -i eth0 -o eth1 -p tcp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT


iptables -t filter -I FORWARD -i eth1 -o eth0 -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT



# Fazendo DNAT, para acessarem o servidor FTP de fora da sua rede lan:
# Eles iram accessar a sua rede DMZ( Zona Desmilitarizada)

iptables -t nat -I PREROUTING -i eth2  -p tcp -m tcp --dport 21 -j DNAT --to-destination 172.16.1.1:21

iptables -t nat -I PREROUTING -i eth0  -p tcp -m tcp --dport 21 -j DNAT --to-destination 172.16.1.1:21


















