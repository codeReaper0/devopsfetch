#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

LOG_FILE="/var/log/devopsfetch.log"

# Install dependencies
apt-get update
apt-get install -y python3 python3-pip net-tools docker.io nginx

# Install required Python packages
pip3 install psutil tabulate

# Copy Python script to /usr/local/bin
cp devopsfetch.py /usr/local/bin/devopsfetch.py
chmod +x /usr/local/bin/devopsfetch.py

# Setup systemd service
cp devopsfetch.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable devopsfetch
systemctl start devopsfetch

# Create logrotate configuration
tee /etc/logrotate.d/devopsfetch > /dev/null <<EOL
/var/log/devopsfetch.log {
    daily
    rotate 7
    compress
    missingok
    notifempty
    create 644 root root
    sharedscripts
    postrotate
        systemctl reload devopsfetch.service > /dev/null 2>/dev/null || true
    endscript
    su root root
}
EOL

# Ensure the log file exists and has the correct permissions
touch "$LOG_FILE"
chown root:root "$LOG_FILE"
chmod 644 "$LOG_FILE"

echo "Setup completed. DevOpsFetch service is now running and logs are managed."
echo "You can now use it by running 'sudo /usr/local/bin/devopsfetch.py' followed by the appropriate flags."
echo "The monitoring service has also been set up and started."
