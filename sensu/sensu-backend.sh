#! /bin/bash

# Hent Alpine-based image
docker pull sensu/sensu

# Install docker-compose
sudo apt install docker-compose

# Start sensu-backend
docker-compose up -d
