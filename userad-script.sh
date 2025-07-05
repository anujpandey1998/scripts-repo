#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root"
  exit
fi

# Check if Jenkins user exists
if id "jenkins" &>/dev/null; then
  echo "User 'jenkins' exists"
else
  echo "User 'jenkins' does not exist. Creating user..."
  useradd -m -s /bin/bash jenkins
fi

# Add Jenkins to sudoers (only if not already added)
if sudo grep -q "^jenkins" /etc/sudoers; then
  echo "Jenkins already has sudo privileges."
else
  echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
  echo "Sudo access granted to jenkins."
fi


chmod +x add-jenkins-sudo.sh

sudo ./add-jenkins-sudo.sh


