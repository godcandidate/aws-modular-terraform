#!/bin/bash
set -e

# Setup logging
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Starting user data script..."

# Update system packages
apt update -y
apt upgrade -y


# install docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh

# Start and enable Docker service
systemctl start docker
systemctl enable docker

# Add ubuntu user to docker group
usermod -aG docker ubuntu

# Pull and run the Docker container
echo "Pulling Docker image: ${docker_image}"
docker pull ${docker_image}

echo "Running Docker container..."
docker run -d \
  --name qr-app-container \
  --restart always \
  -p 80:80 \
  ${docker_image}

echo "User data script completed successfully"