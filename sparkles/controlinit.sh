#! /bin/bash

wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/docker.sh
wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/agent.sh
wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/sparkles/kubernetes/control.sh
sudo chmod +x docker.sh
sudo chmod +x agent.sh
sudo chmod +x control.sh
sudo ./docker.sh
sudo ./agent.sh
sudo ./control.sh
