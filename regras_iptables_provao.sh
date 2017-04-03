#!/bin/bash
clear

iptables -F
iptables -t nat -F
clear


# SNAT and DNAT:

iptables -t nat -I POSTROUTING -s 192.168.40.1/32 -j MASQUERADE


iptables -t nat -I POSTROUTING -s 172.16.40.1/32 -j MASQUERADE

iptables -t nat -I PREROUTING -d 10.0.40.6 -p tcp --dport 22 -j DNAT --to 172.16.40.1:22


iptables -t nat -I PREROUTING -d 192.168.40.254  -p tcp --dport 22 -j DNAT --to 172.16.40.1:22



# Politica padrao drop all na tabela FILTER:


iptables -t filter -P INPUT  DROP
iptables -t filter -P FORWARD DROP
iptables -t filter -P OUTPUT  DROP


iptables -t filter -I FORWARD -i eth0 -o eth2 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT 

iptables -t filter -I FORWARD -i eth2 -o eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT


iptables -t filter -I FORWARD -i eth1 -o eth2 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT 

iptables -t filter -I FORWARD -i eth2 -o eth1 -m state --state ESTABLISHED,RELATED -j ACCEPT



iptables -t filter -I FORWARD -i eth2 -o eth1 -p tcp --dport 22 -m state --state NEW -j ACCEPT


iptables -t filter -I FORWARD -i eth0 -o eth1 -p tcp --dport 22 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT 

iptables -t filter -I FORWARD -i eth1 -o eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT

