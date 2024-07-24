#!/bin/bash

# Display help information
show_help() {
    echo "Usage: devopsfetch [OPTIONS]"
    echo "Retrieve and display system information."
    echo
    echo "Options:"
    echo "  -p, --port [PORT]      Show active ports or specific port details"
    echo "  -d, --docker [NAME]    List Docker images/containers or details of a specific container"
    echo "  -n, --nginx [DOMAIN]   Show Nginx configurations or details of a specific domain"
    echo "  -u, --users [USER]     Show user logins or details of a specific user"
    echo "  -t, --time RANGE       Show activities within a specified time range (e.g., '1 hour ago')"
    echo "  -h, --help             Display this help message"
}

# Function to list active ports
list_ports() {
    echo "USER PORT SERVICE"
    if [ -z "$1" ]; then
        ss -tuln | awk 'NR>1 {split($5, a, ":"); print a[length(a)]}' | sort -u | while read port; do
            lsof -i :$port -sTCP:LISTEN -n -P 2>/dev/null | awk 'NR>1 {print $3, $9, $1}' | awk -v p=$port '{split($2, a, ":"); if (a[length(a)] == p) print $1, p, $3}' | sort -u
        done
    else
        lsof -i :$1 -sTCP:LISTEN -n -P 2>/dev/null | awk 'NR>1 {print $3, $9, $1}' | awk -v p=$1 '{split($2, a, ":"); if (a[length(a)] == p) print $1, p, $3}' | sort -u
    fi | column -t
}

# Function to list Docker containers or images
list_docker() {
    if [ -z "$1" ]; then
        docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Image}}\t{{.ID}}"
    else
        docker inspect "$1" | jq '.[0] | {Name: .Name, State: .State.Status, Image: .Config.Image, ID: .Id}'
    fi
}

# Function to show Nginx configurations
show_nginx() {
    if [ -z "$1" ]; then
        grep -R server_name /etc/nginx/sites-enabled/ | awk '{print $2 " " $3}' | sed 's/;//' | column -t
    else
        grep -R -A 10 "server_name $1" /etc/nginx/sites-enabled/
    fi
}

# Function to show user login information
show_users() {
    if [ -z "$1" ]; then
        last | head -n 10 | column -t
    else
        last "$1" | head -n 5 | column -t
    fi
}

# Function to display system activities within a time range
display_time_range() {
    if [ $# -eq 0 ]; then
        echo "Please specify a time range or date"
        return 1
    elif [ $# -eq 1 ]; then
        start_date=$(date -d "$1" +"%Y-%m-%d 00:00:00")
        end_date=$(date -d "$1 + 1 day" +"%Y-%m-%d 00:00:00")
    elif [ $# -eq 2 ]; then
        start_date=$(date -d "$1" +"%Y-%m-%d 00:00:00")
        end_date=$(date -d "$2 + 1 day" +"%Y-%m-%d 00:00:00")
    else
        echo "Invalid number of arguments for time range"
        return 1
    fi

    journalctl --since "$start_date" --until "$end_date"
}

# Main script logic
case "$1" in
    -p|--port)
        list_ports "$2"
        ;;
    -d|--docker)
        list_docker "$2"
        ;;
    -n|--nginx)
        show_nginx "$2"
        ;;
    -u|--users)
        show_users "$2"
        ;;
    -t|--time)
        shift
        display_time_range "$@"
        ;;
    -h|--help)
        show_help
        ;;
    *)
        echo "Invalid option. Use -h or --help for usage information."
        exit 1
        ;;
esac
