#!/bin/bash
set -e
# Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# # Compose
# sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# sudo chmod +x /usr/local/bin/docker-compose

sudo cat > docker.cfg <<- EOM
  {
    "data-root": "$MOUNT_PATH",
    "storage-driver": "overlay2"
  }
EOM
sudo mv docker.cfg /etc/docker/daemon.json
sudo systemctl restart docker
sudo usermod -aG docker $USER