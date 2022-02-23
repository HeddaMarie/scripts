#! /bin/bash
apt install gitlab-runner -y
wget docker-compose.yml
export GITLAB_HOME=/srv/gitlab
mkdir -p /srv/gitlab
chmod 777 /srv/gitlab
docker-compose up -d
