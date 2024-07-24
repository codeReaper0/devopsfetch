# DevOpsFetch by CodeReaper

DevOpsFetch is a tool designed for system information retrieval and monitoring. It can collect and display data such as active ports, Docker images and containers, Nginx domains, and user logins. It also includes a systemd service for continuous monitoring and logging.

## Features

- **Ports:** Display all active ports and services.
- **Docker:** List all Docker images and containers.
- **Nginx:** Display all Nginx domains and their ports.
- **Users:** List all users and their last login times.
- **Time Range:** Display activities within a specified time range.
- **Monitoring Mode:** Continuously monitor and log system activities.

## Requirements

- Ubuntu or Debian-based system
- Python 3
- Docker
- Nginx

## Installation

### Step 1: Download and Prepare the Scripts

Download the `devopsfetch.py` script, `devopsfetch.service` file, and `install.sh` script from the repository.

### Step 2: Run the Installation Script

Run the `install.sh` script to install necessary dependencies, set up the Python script, and configure the systemd service.

```sh
sudo ./install.sh
```

Verify the Installation
Ensure the installation was successful by checking the status of the systemd service:

```sh
Copy code
sudo systemctl status devopsfetch
```

Usage
You can use DevOpsFetch with various flags to retrieve specific information. The following sections describe each available option.

Display Active Ports
To display all active ports and services:

sh
Copy code
python3 /usr/local/bin/devopsfetch.py -p
List Docker Images
To list all Docker images:

sh
Copy code
python3 /usr/local/bin/devopsfetch.py -d images
List Docker Containers
To list all Docker containers:

sh
Copy code
python3 /usr/local/bin/devopsfetch.py -d containers
Display Nginx Domains and Ports
To display all Nginx domains and their ports:

sh
Copy code
python3 /usr/local/bin/devopsfetch.py -n
List Users and Their Last Login Times
To list all users and their last login times:

sh
Copy code
python3 /usr/local/bin/devopsfetch.py -u
Display Activities Within a Specified Time Range
To display activities within a specified time range, provide the start and end times:

sh
Copy code
python3 /usr/local/bin/devopsfetch.py -t "2024-07-01 00:00:00" "2024-07-23 23:59:59"
Monitoring Mode
DevOpsFetch can also run in monitoring mode as a systemd service, which logs information periodically. This mode is set up and started automatically by the installation script.

Logs
Logs are managed using logrotate and can be found at /var/log/devopsfetch.log. The log file is rotated daily, and up to 7 days of logs are kept. Logs are compressed after rotation.

Help
To display the help message with usage instructions, run:

sh
Copy code
python3 /usr/local/bin/devopsfetch.py -h
Uninstallation
To stop and disable the DevOpsFetch service, and remove installed files, run:

sh
Copy code
sudo systemctl stop devopsfetch
sudo systemctl disable devopsfetch
sudo rm /usr/local/bin/devopsfetch.py
sudo rm /etc/systemd/system/devopsfetch.service
sudo rm /etc/logrotate.d/devopsfetch
sudo rm /var/log/devopsfetch.log
sudo systemctl daemon-reload
This will remove the DevOpsFetch service, its executable script, logrotate configuration, and log file.

This README provides detailed instructions for installation, usage, and uninstallation of the DevOpsFetch tool. Ensure all commands are run with the necessary privileges, especially those requiring sudo.
