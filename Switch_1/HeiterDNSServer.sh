# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "`dircolors`"
# alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
apt-get update
apt-get install bind9 -y

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