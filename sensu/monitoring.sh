#! /bin/bash
# Installation for Sensu, Sensu-agent, sensuctl, InfluxDB and Grafana

# SENSU
# Hent Alpine-based image
docker pull sensu/sensu

# Install docker-compose
sudo apt install docker-compose -y

# Start sensu-backend
docker-compose up -d


# SENSU-AGENT
# Add the Sensu repository
curl -s https://packagecloud.io/install/repositories/sensu/stable/script.deb.sh | sudo bash

# Install the sensu-go-cli package
sudo apt-get install sensu-go-cli

# Configure senscutl (dobbeltsjekk om fnuttene skal være der eller ikke)
sensuctl configure -n \
--username 'admin' \
--password 'admin' \
--namespace default \
--url 'http://127.0.0.1:8080'

# Add the Sensu repository
curl -s https://packagecloud.io/install/repositories/sensu/stable/script.deb.sh | sudo bash

# Install the sensu-go-agent package
sudo apt-get install sensu-go-agent

# Copy the config template from the docs
sudo curl -L https://docs.sensu.io/sensu-go/latest/files/agent.yml -o /etc/sensu/agent.yml

# Start sensu-agent using a service manager
sudo systemctl start sensu-agent

# Verifiser at Sensu keepalive er der
sensuctl entity list

# Restart agent tilfelle den ikke dukker opp i dashboard
sudo service sensu-agent restart


# INFLUXDB
# Get the InfluxDB GDG data key. It should respond with OK
curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add

# Add new influxdb.list repository file
echo "deb https://repos.influxdata.com/ubuntu bionic stable" | sudo tee /etc/apt/sources.list.d/influxdb.list

apt update

# Install influxdb package
apt install influxdb

# Start InfluxDB and configure
systemctl start influxdb
systemctl enable influxdb

# Check that you get influxdb ports ‘8088’and ‘8086’ on the ‘LISTEN’ state
netstat -plntu

# Install influxdb-client
apt install influxdb-client



# GRAFANA

# Install, add Grafana key and repository
sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# After the repository is added, update and install
sudo apt-get update
sudo apt-get install grafana -y

# Move grafana.yml to /etc/grafana/provisioning/datasources
mv influxdb.yml /etc/grafana/provisioning/datasources/influxdb.yml

# After installation, start and enable grafana-server
# sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

# Check if InfluxDB server is running (shown as active in green)
systemctl status influxdb
