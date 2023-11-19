apt-get update
apt-get install nginx php7.3 php7.3-fpm wget zip htop -y



echo '
geo $allowed {
    default     0;
    10.14.3.69  1;
    10.14.3.70  1;
    10.14.4.167 1;
    10.14.4.168 1;
}


server {
    listen 80;
    server_name granz.channel.b11.com www.granz.channel.b11.com;

    

    location /its {
        proxy_pass https://its.ac.id;
    }

    location / {
        proxy_set_header Host $host;
        if ($allowed) {
            proxy_pass http://10.14.2.2; #IP Eisen
        }
        proxy_pass http://127.0.0.1:8000;
    }
}' > /etc/nginx/sites-available/lb-proxy

ln -s /etc/nginx/sites-available/lb-proxy /etc/nginx/sites-enabled/lb-proxy

wget -O '/var/www/jarkom.zip' 'https://drive.google.com/uc?id=1ViSkRq7SmwZgdK64eRbr5Fm1EGCTPrU1&export=download'
unzip -o /var/www/jarkom.zip -d /var/www/
rm /var/www/jarkom.zip

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

ln -s /etc/nginx/sites-available/modul-3 /etc/nginx/sites-enabled/modul-3

rm /etc/nginx/sites-enabled/default

service nginx restart
service php7.3-fpm stop
service php7.3-fpm start

