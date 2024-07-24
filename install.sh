#!/bin/bash

# Verify if the script is executed with root privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Update package list and install required packages
apt-get update
apt-get install -y nginx docker.io jq

# Deploy the main script to /usr/local/bin
cp devopsfetch /usr/local/bin/
chmod +x /usr/local/bin/devopsfetch

# Create systemd service for continuous monitoring
cat << EOF > /etc/systemd/system/devopsfetch.service
[Unit]
Description=DevOpsFetch Service for System Monitoring
After=network.target

[Service]
ExecStart=/usr/local/bin/devopsfetch -t '1 hour ago'
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# Enable and initiate the systemd service
systemctl enable devopsfetch.service
systemctl start devopsfetch.service

# Configure log rotation for devopsfetch logs
cat << EOF > /etc/logrotate.d/devopsfetch
/var/log/devopsfetch.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 0640 root root
}
EOF

echo "Installation complete!"
