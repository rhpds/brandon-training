#!/bin/bash
USER=rhel

echo "Adding wheel" > /root/post-run.log
usermod -aG wheel rhel

echo "Setup vm control01" > /tmp/progress.log

chmod 666 /tmp/progress.log 

#dnf install -y nc

# --- Cockpit (RHEL web console) ---
# Install cockpit
dnf install -y cockpit

# Open the guest firewall for 9090 (Service target)
firewall-cmd --add-service=cockpit --permanent
firewall-cmd --reload

# Enable cockpit functionality in showroom (Edge route + iframe)
echo "[WebService]" > /etc/cockpit/cockpit.conf
echo "Origins = https://cockpit-${GUID}.${DOMAIN}" >> /etc/cockpit/cockpit.conf
echo "AllowUnencrypted = true" >> /etc/cockpit/cockpit.conf
echo "ProtocolHeader = X-Forwarded-Proto" >> /etc/cockpit/cockpit.conf


# Enable the socket last, with config in place
systemctl enable --now cockpit.socket

# --- Apache (HTTP web server) ---
# Install httpd (Apache)
dnf install -y httpd

# Open the guest firewall for 80
firewall-cmd --add-service=http --permanent
firewall-cmnd --reload

# Enable Apache to work with Showroom's Edge route
# Create default index.html
mkdir -p /var/www/html
echo "<h1>Apache is running!</h1>" > /var/www/html/index.html

# Enable and start Apache
systemctl enable --now httpd
