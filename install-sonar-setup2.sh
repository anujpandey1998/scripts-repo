#!/bin/bash

# ------------------------------------------
# SonarQube + PostgreSQL + Nginx Setup Script
# ------------------------------------------

echo "[1/12] Updating system and installing Java..."
apt update -y
apt install openjdk-17-jdk wget unzip zip net-tools curl gnupg2 -y
java -version

echo "[2/12] Tuning system for SonarQube..."
cp /etc/sysctl.conf /root/sysctl.conf_backup
echo 'vm.max_map_count=262144' >> /etc/sysctl.conf
echo 'fs.file-max=65536' >> /etc/sysctl.conf
sysctl -p

cp /etc/security/limits.conf /root/sec_limit.conf_backup
tee -a /etc/security/limits.conf >/dev/null <<EOL
sonar   -   nofile   65536
sonar   -   nproc    4096
EOL

echo "[3/12] Installing PostgreSQL..."
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
apt update -y
apt install postgresql postgresql-contrib -y
systemctl enable postgresql
systemctl start postgresql

echo "[4/12] Creating SonarQube DB and user..."
sudo -i -u postgres psql <<EOF
ALTER USER postgres WITH PASSWORD 'admin123';
CREATE USER sonar WITH ENCRYPTED PASSWORD 'admin123';
CREATE DATABASE sonarqube OWNER sonar;
GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;
EOF

echo "[5/12] Installing SonarQube 9.9.8..."
mkdir -p /sonarqube && cd /sonarqube
curl -O https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.8.100196.zip
unzip -o sonarqube-9.9.8.100196.zip -d /opt/
mv /opt/sonarqube-9.9.8.100196 /opt/sonarqube

echo "[6/12] Creating sonar user and setting permissions..."
groupadd sonar
useradd -c "SonarQube - User" -d /opt/sonarqube -g sonar sonar
chown -R sonar:sonar /opt/sonarqube

echo "[7/12] Configuring SonarQube..."
cp /opt/sonarqube/conf/sonar.properties /root/sonar.properties_backup
tee /opt/sonarqube/conf/sonar.properties >/dev/null <<EOL
sonar.jdbc.username=sonar
sonar.jdbc.password=admin123
sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube
sonar.web.host=0.0.0.0
sonar.web.port=9000
sonar.web.javaAdditionalOpts=-server
sonar.search.javaOpts=-Xmx512m -Xms512m -XX:+HeapDumpOnOutOfMemoryError
sonar.log.level=INFO
sonar.path.logs=logs
EOL

echo "[8/12] Creating SonarQube systemd service..."
tee /etc/systemd/system/sonarqube.service >/dev/null <<EOL
[Unit]
Description=SonarQube service
After=network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonar
Group=sonar
Restart=always
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload
systemctl enable sonarqube

echo "[9/12] Installing and configuring Nginx reverse proxy..."
apt install nginx -y
rm -f /etc/nginx/sites-enabled/default
rm -f /etc/nginx/sites-available/default

tee /etc/nginx/sites-available/sonarqube >/dev/null <<EOL
server {
    listen 80;
    server_name sonarqube.groophy.in;

    access_log  /var/log/nginx/sonar.access.log;
    error_log   /var/log/nginx/sonar.error.log;

    proxy_buffers 16 64k;
    proxy_buffer_size 128k;

    location / {
        proxy_pass  http://127.0.0.1:9000;
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
        proxy_redirect off;

        proxy_set_header    Host            \$host;
        proxy_set_header    X-Real-IP       \$remote_addr;
        proxy_set_header    X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header    X-Forwarded-Proto http;
    }
}
EOL

ln -s /etc/nginx/sites-available/sonarqube /etc/nginx/sites-enabled/sonarqube
systemctl enable nginx

echo "[10/12] Allowing firewall ports..."
ufw allow 80,9000,9001/tcp

echo "[11/12] Start SonarQube and Nginx..."
systemctl start sonarqube
systemctl restart nginx

echo "[12/12] Setup complete. Access SonarQube at: http://<your-server-ip>/"

# Optional reboot
echo "System will reboot in 30 seconds..."
sleep 30
reboot
  
