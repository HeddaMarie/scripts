#! /bin/bash
# Update and upgrade
sudo apt update
sudo apt upgrade -y

# docker.sh
wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/docker.sh

# docker-compose.yml
wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/sensu/docker-compose.yml

# influxdb.yml
wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/sensu/influxdb.yml

# sensu-backend.sh
wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/sensu/sensu-backend.sh

# monitoring.sh
wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/sensu/monitoring.sh

# Give permissions
sudo chmod +x sensu-backend.sh monitoring.sh

# Start scripts
sudo ./sensu-backend.sh
sudo ./monitoring.sh

