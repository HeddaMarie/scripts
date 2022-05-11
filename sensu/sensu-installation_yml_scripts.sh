#! /bin/bash
# Update and upgrade
sudo apt update
sudo apt upgrade -y

# agent.sh
wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/agent.sh

# docker.sh
wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/docker.sh

# docker-compose.yml, source: https://oslomet.instructure.com/courses/23075/files/2636846?module_item_id=416082
wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/sensu/docker-compose.yml

# sensu-daemonset.yml, source: https://github.com/sensu/sensu-k8s-quick-start
wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/sensu/sensu-daemonset.yml

# influxdb.yml, source: https://oslomet.instructure.com/courses/23075/files/2636990?module_item_id=416151
wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/sensu/influxdb.yml

# monitoring.sh, source: https://oslomet.instructure.com/courses/23075/files/2636990?module_item_id=416151 and
# source: https://grafana.com/docs/grafana/latest/installation/debian/ and https://www.vultr.com/docs/how-to-install-influxdb-on-ubuntu-20-04/  
wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/sensu/monitoring.sh

# Give permissions
sudo chmod +x agent.sh docker.sh monitoring.sh

# Start scripts
sudo ./agent.sh
sudo ./monitoring.sh
