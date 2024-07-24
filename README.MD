# DevOpsFetch by CodeReaper

DevOpsFetch is a comprehensive command-line tool tailored for DevOps professionals to efficiently gather and display essential system information. It facilitates quick access to details about active ports, Docker containers, Nginx configurations, user logins, and system activities over specified time intervals.

## Features

- Display active ports and services
- List Docker images and containers
- Show Nginx domain configurations
- View user login information
- Monitor system activities within custom time ranges
- Formatted output for easy readability

## Installation

### Steps to Install

1. Clone this repository:

   ```sh
   git clone https://github.com/codeReaper0/devopsfetch.git
   cd devopsfetch
   Make the installation script executable:
   ```

```sh
chmod +x install.sh
```

Run the installation script with root privileges:

```sh
sudo ./install.sh
```

### Running the Tool

View help options:

```sh
devopsfetch -h
```

### Usage

Command Options
-p, --port [PORT]: Display active ports or specific port information
-d, --docker [NAME]: List Docker images/containers or specific container information
-n, --nginx [DOMAIN]: Display Nginx domains or specific domain configuration
-u, --users [USER]: List users and their last login times or specific user information
-t, --time RANGE: Display activities within a time range (e.g., '1 hour ago')
-h, --help: Display this help message

### Examples

Display all active ports:

```sh
devopsfetch -p
```

### Display information about a specific port:

```sh
devopsfetch -p 80
```

### List all Docker containers:

```sh
devopsfetch -d
```

### Get detailed information about a specific Docker container:

```sh
devopsfetch -d container_name
```

### Display all Nginx domains:

```sh
devopsfetch -n
```

### Get Nginx configuration for a specific domain:

```sh
devopsfetch -n website.com
```

### List all users and their last login times:

```sh
devopsfetch -u
```

### Get last login information for a specific user:

```sh
devopsfetch -u username
```

### Display activities within the last hour:

```sh
devopsfetch -t '6 hour ago'
```

### Date Range Queries

DevOpsFetch supports time-based queries to show system activities within specific date ranges:

### To show activities for a specific date:

```sh
devopsfetch --time '2024-07-24'
```

### To show activities within a date range:

```sh
devopsfetch --time '2024-07-24' '2024-07-25'
```

### Detailed Installation Process

The install.sh script performs the following actions:

### Updates the system package list.

Installs necessary dependencies:
nginx
docker.io
jq (for JSON parsing)
Copies the main devopsfetch script to /usr/local/bin/, making it accessible system-wide.
Sets the appropriate permissions to make the script executable.
Creates a systemd service file (/etc/systemd/system/devopsfetch.service) to run the script periodically.
Enables and starts the systemd service.
Configures log rotation for the devopsfetch logs to manage log file sizes and retention.
After running the installation script, devopsfetch will be installed as a system-wide command, and a background service will be set up to periodically collect and log system information.

### ninstallation

To uninstall devopsfetch:

### Stop and disable the systemd service:

```sh
sudo systemctl stop devopsfetch.service
sudo systemctl disable devopsfetch.service
```

### Remove the service file:

```sh
sudo rm /etc/systemd/system/devopsfetch.service
```

### Remove the main script:

```sh
sudo rm /usr/local/bin/devopsfetch
```

### Remove the log rotation configuration:

```sh
sudo rm /etc/logrotate.d/devopsfetch
```
