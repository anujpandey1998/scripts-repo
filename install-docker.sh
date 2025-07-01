#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Updating package index..."
sudo apt-get update -y

echo "Installing prerequisites..."
sudo apt-get install -y ca-certificates curl gnupg lsb-release

echo "Adding Docker's official GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Updating package index again..."
sudo apt-get update -y

echo "Installing Docker Engine and related components..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Enabling Docker to start on boot..."
sudo systemctl enable docker

echo "Starting Docker service..."
sudo systemctl start docker

echo "Adding current user to docker group (optional)..."
sudo usermod -aG docker $USER

echo "Docker installation complete. You may need to log out and log back in for group changes to take effect."

# run the script in ec2
#./install-docker.sh

