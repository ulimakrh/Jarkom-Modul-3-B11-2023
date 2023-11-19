cd ~
apt update -y
echo 'nameserver 10.14.1.2
nameserver 192.168.122.1
' > /etc/resolv.conf
apt-get -y install lynx