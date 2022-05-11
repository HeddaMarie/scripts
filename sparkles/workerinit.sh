#! /bin/bash

wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/docker.sh
wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/agent.sh
wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/sparkles/kubernetes/worker.sh
sudo chmod +x docker.sh
sudo chmod +x agent.sh
sudo chmod +x worker.sh
sudo ./docker.sh
sudo ./agent.sh
sudo ./worker.sh
