#! /bin/bash
# Update and upgrade
sudo apt update
sudo apt upgrade -y

# agent.sh
wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/agent.sh

# docker.sh
wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/docker.sh

# docker-compose.yml
wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/sensu/docker-compose.yml

# sensu-daemonset.yml
wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/sensu/sensu-daemonset.yml

# influxdb.yml
wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/sensu/influxdb.yml

# monitoring.sh
wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/sensu/monitoring.sh

# Give permissions
sudo chmod +x agent.sh docker.sh monitoring.sh

# Start scripts
sudo ./agent.sh
sudo ./monitoring.sh
