#!/bin/bash

# Update package index
sudo apt update -y

# Install Java 21 Runtime (OpenJDK)
sudo apt install -y fontconfig openjdk-21-jdk

# Verify Java installation
java -version

# Add Jenkins repository key and source list
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /etc/apt/keyrings/jenkins-keyring.asc > /dev/null

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package index again after adding Jenkins repo
sudo apt update -y

# Install Jenkins
sudo apt install -y jenkins

# Enable Jenkins to start on boot
sudo systemctl enable jenkins

# Start Jenkins
sudo systemctl start jenkins

# Check Jenkins status
sudo systemctl status jenkins


