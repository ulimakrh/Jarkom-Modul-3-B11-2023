# Jarkom-Modul-3-B11-2023

| No | Nama | NRP |
| -------- | -------- | -------- |
| 1 | Muhammad Rafif Tri Risqullah | 5025211009 |
| 2 | Ulima Kaltsum Rizky Hibatullah | 5025211232 |

Topologi

![image](https://github.com/ulimakrh/Jarkom-Modul-3-B11-2023/assets/114993076/b4c2c91e-672e-411b-bad3-025ab97ed986)

Konfigurasi
1. Aura -> Router // DHCP Relay
```
auto eth0
iface eth0 inet dhcp
up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.14.0.0/16

auto eth1
iface eth1 inet static
	address 10.14.1.10
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 10.14.2.10
	netmask 255.255.255.0


auto eth3
iface eth3 inet static
	address 10.14.3.10
	netmask 255.255.255.0

auto eth4
iface eth4 inet static
	address 10.14.4.10
	netmask 255.255.255.0
```
2. Himmel -> DHCP Server
```
auto eth0
iface eth0 inet static
	address 10.14.1.2
	netmask 255.255.255.0
	gateway 10.14.1.10
  up echo nameserver 192.168.122.1 > /etc/resolv.conf
```
3. Heiter -> DNS Server
```
auto eth0
iface eth0 inet static
	address 10.14.1.3
	netmask 255.255.255.0
	gateway 10.14.1.10
  up echo nameserver 192.168.122.1 > /etc/resolv.conf
```
4. Denken -> Database Server
```
auto eth0
iface eth0 inet static
	address 10.14.2.1
	netmask 255.255.255.0
	gateway 10.14.2.10
  up echo nameserver 192.168.122.1 > /etc/resolv.conf
```
5. Eisen -> Load Balancer
```
auto eth0
iface eth0 inet static
	address 10.14.2.2
	netmask 255.255.255.0
	gateway 10.14.2.10
  up echo nameserver 192.168.122.1 > /etc/resolv.conf
```
6. Frieren -> Laravel Worker
```
auto eth0
iface eth0 inet static
	address 10.14.4.1
	netmask 255.255.255.0
	gateway 10.14.4.10
  up echo nameserver 192.168.122.1 > /etc/resolv.conf
```
7. Lawine -> PHP Worker
```
auto eth0
iface eth0 inet static
	address 10.14.3.1
	netmask 255.255.255.0
	gateway 10.14.3.10
  up echo nameserver 192.168.122.1 > /etc/resolv.conf
```
8. Linie -> PHP Worker
```
auto eth0
iface eth0 inet static
	address 10.14.3.2
	netmask 255.255.255.0
	gateway 10.14.3.10
  up echo nameserver 192.168.122.1 > /etc/resolv.conf
```
9. Lugner -> PHP Worker
```
auto eth0
iface eth0 inet static
	address 10.14.3.3
	netmask 255.255.255.0
	gateway 10.14.3.10
  up echo nameserver 192.168.122.1 > /etc/resolv.conf
```
10. Revolte, Richter, Sein, dan Stark -> Client
```
auto eth0
iface eth0 inet dhcp
```

