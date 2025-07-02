#!/bin/bash

# Variables
MAVEN_VERSION=3.9.10
MAVEN_ARCHIVE=apache-maven-$MAVEN_VERSION-bin.tar.gz
MAVEN_URL=https://dlcdn.apache.org/maven/maven-3/3.9.10/binaries/$MAVEN_ARCHIVE

# Update package index and install dependencies
sudo apt update -y
sudo apt install -y wget tar

# Download Maven tarball
wget $MAVEN_URL -P /tmp

# Extract to /opt
sudo tar -xzf /tmp/$MAVEN_ARCHIVE -C /opt

# Symlink for easier access
sudo ln -s /opt/apache-maven-$MAVEN_VERSION /opt/maven

# Set environment variables
sudo tee /etc/profile.d/maven.sh > /dev/null <<EOF
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH=\$MAVEN_HOME/bin:\$PATH
EOF

# Apply changes
sudo chmod +x /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh

# Verify installation
mvn -version

