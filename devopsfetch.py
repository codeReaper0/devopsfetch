import argparse
import logging
import psutil
import subprocess
import tabulate

# Set up logging
logging.basicConfig(filename='/var/log/devopsfetch.log', level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def get_active_ports():
    active_ports = []
    for conn in psutil.net_connections():
        if conn.status == psutil.CONN_ESTABLISHED:
            active_ports.append((conn.laddr.port, conn.status, conn.type))
    return active_ports

def get_docker_images():
    docker_images = subprocess.check_output(['docker', 'images']).decode().split('\n')
    return [image.strip() for image in docker_images if image]

def get_docker_containers():
    docker_containers = subprocess.check_output(['docker', 'ps', '-a']).decode().split('\n')
    return [container.strip() for container in docker_containers if container]

def get_nginx_domains():
    nginx_domains = subprocess.check_output(['nginx', '-T']).decode().split('\n')
    return [domain.strip() for domain in nginx_domains if domain]

def get_user_logins():
    user_logins = subprocess.check_output(['last']).decode().split('\n')
    return [login.strip() for login in user_logins if login]

def format_output(data, columns):
    return tabulate.tabulate(data, headers=columns, tablefmt='psql')

def main():
    parser = argparse.ArgumentParser(description='DevOps Fetch')
    parser.add_argument('-p', '--port', action='store_true', help='Display active ports and services')
    parser.add_argument('-d', '--docker', choices=['images', 'containers'], help='List Docker images and containers')
    parser.add_argument('-n', '--nginx', action='store_true', help='Display Nginx domains and ports')
    parser.add_argument('-u', '--users', action='store_true', help='List users and their last login times')
    parser.add_argument('-t', '--time', nargs=2, metavar=('START', 'END'), help='Display activities within a specified time range')
    parser.add_argument('-m', '--monitor', action='store_true', help='Run in monitoring mode')
    parser.add_argument('-h', '--help', action='help', help='Show this help message and exit')

    args = parser.parse_args()

    if args.port:
        ports = get_active_ports()
        columns = ['Port', 'Status', 'Type']
        print(format_output(ports, columns))
    elif args.docker:
        if args.docker == 'images':
            images = get_docker_images()
            print('\n'.join(images))
        elif args.docker == 'containers':
            containers = get_docker_containers()
            print('\n'.join(containers))
    elif args.nginx:
        domains = get_nginx_domains()
        print('\n'.join(domains))
    elif args.users:
        logins = get_user_logins()
        print('\n'.join(logins))
    elif args.time:
        # Implement time range functionality if needed
        pass
    elif args.monitor:
        while True:
            logging.info("Monitoring mode is running")
            # Call necessary functions to log data periodically
            time.sleep(60)
    else:
        parser.print_help()

if __name__ == '__main__':
    main()
