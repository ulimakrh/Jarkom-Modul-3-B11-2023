apt-get update
apt install apache2-utils nginx -y

mkdir /etc/nginx/rahasiakita
echo 'netics:$apr1$OqR2vkbu$iBw4oH0yBK6Y4qZFDIcAb1' > /etc/nginx/rahasiakita/.htpasswd

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
