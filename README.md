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
## Soal dan Jawaban
1. Lakukan konfigurasi sesuai dengan peta yang sudah diberikan.
Langkah pertama yang harus dilakukan adalah menyiapkan konfigurasi topologi dan setup sesuai dengan aturan yang telah ditentukan pada soal. Untuk mengujinya, kita perlu menambahkan registrasi domain, yaitu "riegel.canyon.b11.com" untuk worker Laravel dan "granz.channel.b11.com" untuk worker PHP. Kedua domain ini harus diarahkan ke worker dengan alamat IP address 10.14.x.3.

Dikarenakan pada konfigurasi topologi sebelumnya seluruh worker sudah menggunakan DHCP, maka perlu dilakukan sedikit modifikasi pada node Lugner dan Fern.
- Lugner
```
auto eth0
iface eth0 inet static
	address 10.14.3.3
	netmask 255.255.255.0
	gateway 10.14.3.10
      up echo nameserver 192.168.122.1 > /etc/resolv.conf
```
- Fern
```
auto eth0
iface eth0 inet static
	address 10.14.4.3
	netmask 255.255.255.0
	gateway 10.14.4.10
        up echo nameserver 192.168.122.1 > /etc/resolv.conf
```
Kemudian pada Heiter selaku DNS Server, kita jalankan command di bawah ini atau bisa kita inisiasi ke  root .bashrc.
```
echo 'options {
        directory "/var/cache/bind";

        forwarders {
                192.168.122.1;
        };
        // dnssec-validation auto;
        allow-query{any;};
        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
}; ' >/etc/bind/named.conf.options

mkdir /etc/bind/jarkom

echo 'zone "riegel.canyon.b11.com" {
        type master;
        notify yes;
        file "/etc/bind/jarkom/riegel.canyon.b11.com";
};
zone "granz.channel.b11.com" {
        type master;
        notify yes;
        file "/etc/bind/jarkom/granz.channel.b11.com";
};

' > /etc/bind/named.conf.local

echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     riegel.canyon.b11.com. root.riegel.canyon.b11.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      riegel.canyon.b11.com.
@       IN      A       10.14.4.1
www     IN      CNAME   riegel.canyon.b11.com.
@       IN      AAAA    ::1' > /etc/bind/jarkom/riegel.canyon.b11.com


echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     granz.channel.b11.com. root.granz.channel.b11.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      granz.channel.b11.com.
@       IN      A       10.14.3.1
www     IN      CNAME   granz.channel.b11.com.
@       IN      AAAA    ::1' > /etc/bind/jarkom/granz.channel.b11.com


service bind9 start
```
Lakukan `ping riegel.canyon.b11.com`.


Kemudian, karena masih banyak spell yang harus dikumpulkan, bantulah para petualang untuk memenuhi kriteria berikut.:
1. Semua CLIENT harus menggunakan konfigurasi dari DHCP Server.
2. Client yang melalui Switch3 mendapatkan range IP dari [prefix IP].3.16 - [prefix IP].3.32 dan [prefix IP].3.64 - [prefix IP].3.80 (2)
Untuk ini, kita perlu menambahkan beberapa konfigurasi baru pada switch4 sesuai dengan script berikut ini.
Lakukan setup pada Himmel selaku DHCP Server seperti berikut.
```
echo subnet 10.14.1.0 netmask 255.255.255.0 {
    }

subnet 10.14.3.0 netmask 255.255.255.0 {
}

subnet 10.14.4.0 netmask 255.255.255.0 {
    range 10.14.4.12 10.14.4.20;
    range 10.14.4.160 10.14.4.168;
    option routers 10.14.4.10;
}
" > /etc/dhcp/dhcpd.conf
```
3. Client yang melalui Switch4 mendapatkan range IP dari [prefix IP].4.12 - [prefix IP].4.20 dan [prefix IP].4.160 - [prefix IP].4.168 (3)
Untuk ini, kita perlu menambahkan beberapa konfigurasi baru pada switch4 sesuai dengan script berikut ini.
```
echo subnet 10.14.1.0 netmask 255.255.255.0 {
}
subnet 10.14.3.0 netmask 255.255.255.0 {
    range 10.14.3.16 10.14.3.32;
    range 10.14.3.64 10.14.3.80;
    option routers 10.14.3.10;
}

subnet 10.14.4.0 netmask 255.255.255.0 {
    range 10.14.4.12 10.14.4.20;
    range 10.14.4.160 10.14.4.168;
    option routers 10.14.4.10;
}
" > /etc/dhcp/dhcpd.conf
```
4. Client mendapatkan DNS dari Heiter dan dapat terhubung dengan internet melalui DNS tersebut (4)
Tambahkan konfigurasi berupa `option broadcast-address` dan `option domain-name-server` pada script.
```
echo subnet 10.14.1.0 netmask 255.255.255.0 {
}

subnet 10.14.3.0 netmask 255.255.255.0 {
    range 10.14.3.16 10.14.3.32;
    range 10.14.3.64 10.14.3.80;
    option routers 10.14.3.10;
    option broadcast-address 10.14.3.255;
    option domain-name-servers 10.14.2.2, 192.168.122.1;
}

subnet 10.14.4.0 netmask 255.255.255.0 {
    range 10.14.4.12 10.14.4.20;
    range 10.14.4.160 10.14.4.168;
    option routers 10.14.4.10;
    option broadcast-address 10.14.4.255;
    option domain-name-servers 10.14.2.2, 192.168.122.1;
}
" > /etc/dhcp/dhcpd.conf
```
Kemudian jalankan `service isc-dhcp-server restart` untuk me-restart guna melakukan leasing IP.

![image](https://github.com/ulimakrh/Jarkom-Modul-3-B11-2023/assets/114993076/a8e4a992-4dfc-4fa9-97af-ee483818a5c6)

5. Lama waktu DHCP server meminjamkan alamat IP kepada Client yang melalui Switch3 selama 3 menit sedangkan pada client yang melalui Switch4 selama 12 menit. Dengan waktu maksimal dialokasikan untuk peminjaman alamat IP selama 96 menit (5)
Untuk ini, kita gunakan `default-lease-time` dan `max-lease-team` yang mana satuannya adalah detik.
Karena Switch3 dapat memberikan IP dengan waktu peminjaman selama 3 menit, sementara Switch4 memberikan IP selama 12 menit, maka konfigurasi leasing time pada Switch3 perlu diatur sebesar 180 detik dan pada Switch4 perlu diatur sebesar 720 detik. Selain itu, nilai maksimum untuk max-lease-time adalah 96 menit, atau setara dengan 5760 detik.

```
subnet 10.14.1.0 netmask 255.255.255.0 {
}

subnet 10.14.3.0 netmask 255.255.255.0 {
    range 10.14.3.16 10.14.3.32;
    range 10.14.3.64 10.14.3.80;
    option routers 10.14.3.10;
    option broadcast-address 10.14.3.255;
    option domain-name-servers 10.14.2.2, 192.168.122.1;
    default-lease-time 180;
    max-lease-time 5760;
}

subnet 10.14.4.0 netmask 255.255.255.0 {
    range 10.14.4.12 10.14.4.20;
    range 10.14.4.160 10.14.4.168;
    option routers 10.14.4.10;
    option broadcast-address 10.14.4.255;
    option domain-name-servers 10.14.2.2, 192.168.122.1;
    default-lease-time 720;
    max-lease-time 5760;
}
" > /etc/dhcp/dhcpd.conf
```


Berjalannya waktu, petualang diminta untuk melakukan deployment.
1. Pada masing-masing worker PHP, lakukan konfigurasi virtual host untuk website berikut dengan menggunakan php 7.3. (6)
Lakukan command berikut ini untuk melakukan download dan unzip.
```
wget -O '/var/www/jarkom.zip' 'https://drive.google.com/uc?id=1ViSkRq7SmwZgdK64eRbr5Fm1EGCTPrU1&export=download'
unzip -o /var/www/jarkom.zip -d /var/www/
rm /var/www/jarkom.zip
```
Setelah itu, lakukan konfigurasi pada nginx sebagai berikut.
```
echo '
 server {

 	listen 8000;

 	root /var/www/modul-3;

 	index index.php index.html index.htm;
 	server_name _;

 	location / {
 			try_files $uri $uri/ /index.php?$query_string;
 	}

 	# pass PHP scripts to FastCGI server
 	location ~ \.php$ {
 	include snippets/fastcgi-php.conf;
 	fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
 	}

    location ~ /\.ht {
 			deny all;
 	}

 	error_log /var/log/nginx/jarkom_error.log;
 	access_log /var/log/nginx/jarkom_access.log;
 }
' > /etc/nginx/sites-available/modul-3
```
Jalankan command `lynx localhost` pada masing-masing worker.

3. Kepala suku dari Bredt Region memberikan resource server sebagai berikut:
   - Lawine, 4GB, 2vCPU, dan 80 GB SSD.
   - Linie, 2GB, 2vCPU, dan 50 GB SSD.
   - Lugner 1GB, 1vCPU, dan 25 GB SSD.
aturlah agar Eisen dapat bekerja dengan maksimal, lalu lakukan testing dengan 1000 request dan 100 request/second. (7)

Sebelum melakukan lakukan konfigurasi pada node Eisen , buka kembali Node DNS Server dan arahkan domain tersebut pada IP Load Balancer Eisen.
Lalu pada node Eisen, lakukan konfigurasi pada nginx sebagai berikut.
```
echo ' # Default menggunakan Round Robin
upstream granz  {
 	server 10.14.3.1:8000; #IP Lawine
 	server 10.14.3.2:8000; #IP Linie
    server 10.14.3.3:8000; #IP Lugner
 }

upstream riegel  {
    least_conn;
 	server 10.14.4.1:8000; #IP Frieren
 	server 10.14.4.2:8000; #IP Flamme
    server 10.14.4.3:8000; #IP Fern
 }

 server {
 	listen 80;
 	server_name granz.channel.b11.com www.granz.channel.b11.com;

    auth_basic "Authorization";
    auth_basic_user_file /etc/nginx/rahasiakita/.htpasswd;

 	location / {
        proxy_pass http://granz;
 	}
 }
 
 server {
 	listen 80;
 	server_name riegel.canyon.b11.com www.riegel.canyon.b11.com;

 	location / {
        proxy_pass http://riegel;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
 	}
 }' > /etc/nginx/sites-available/lb-proxy

ln -s /etc/nginx/sites-available/lb-proxy /etc/nginx/sites-enabled/lb-proxy

rm /etc/nginx/sites-enabled/default

service nginx restart
```
Jalankan command `ab -n 1000 -c 100 http://www.granz.channel.b11.com/ ` pada salah satu client seperti Revolte.

4. Karena diminta untuk menuliskan grimoire, buatlah analisis hasil testing dengan 200 request dan 10 request/second masing-masing algoritma Load Balancer dengan ketentuan sebagai berikut:
	- Nama Algoritma Load Balancer
	- Report hasil testing pada Apache Benchmark
	- Grafik request per second untuk masing masing algoritma.
	- Analisis (8)

5. Dengan menggunakan algoritma Round Robin, lakukan testing dengan menggunakan 3 worker, 2 worker, dan 1 worker sebanyak 100 request dengan 10 request/second, kemudian tambahkan grafiknya pada grimoire. (9)


6. Selanjutnya coba tambahkan konfigurasi autentikasi di LB dengan dengan kombinasi username: “netics” dan password: “ajkyyy”, dengan yyy merupakan kode kelompok. Terakhir simpan file “htpasswd” nya di /etc/nginx/rahasisakita/ (10)

7. Lalu buat untuk setiap request yang mengandung /its akan di proxy passing menuju halaman https://www.its.ac.id. (11) hint: (proxy_pass)

8. Selanjutnya LB ini hanya boleh diakses oleh client dengan IP [Prefix IP].3.69, [Prefix IP].3.70, [Prefix IP].4.167, dan [Prefix IP].4.168. (12) hint: (fixed in dulu clinetnya)

Karena para petualang kehabisan uang, mereka kembali bekerja untuk mengatur riegel.canyon.yyy.com.
1. Semua data yang diperlukan, diatur pada Denken dan harus dapat diakses oleh Frieren, Flamme, dan Fern. (13)
2. Frieren, Flamme, dan Fern memiliki Riegel Channel sesuai dengan quest guide berikut. Jangan lupa melakukan instalasi PHP8.0 dan Composer (14)
3. Riegel Channel memiliki beberapa endpoint yang harus ditesting sebanyak 100 request dengan 10 request/second. Tambahkan response dan hasil testing pada grimoire.
   - POST /auth/register (15)
   - POST /auth/login (16)
   - GET /me (17)
4. Untuk memastikan ketiganya bekerja sama secara adil untuk mengatur Riegel Channel maka implementasikan Proxy Bind pada Eisen untuk mengaitkan IP dari Frieren, Flamme, dan Fern. (18)
5. Untuk meningkatkan performa dari Worker, coba implementasikan PHP-FPM pada Frieren, Flamme, dan Fern. Untuk testing kinerja naikkan 
- pm.max_children
- pm.start_servers
- pm.min_spare_servers
- pm.max_spare_servers
sebanyak tiga percobaan dan lakukan testing sebanyak 100 request dengan 10 request/second kemudian berikan hasil analisisnya pada Grimoire.(19)
6. Nampaknya hanya menggunakan PHP-FPM tidak cukup untuk meningkatkan performa dari worker maka implementasikan Least-Conn pada Eisen. Untuk testing kinerja dari worker tersebut dilakukan sebanyak 100 request dengan 10 request/second. (20)


