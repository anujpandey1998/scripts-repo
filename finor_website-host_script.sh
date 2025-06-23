#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Install Apache HTTP Server, wget,git, and unzip
yum install -y httpd wget unzip git

# Start and enable Apache to run on boot
systemctl start httpd
systemctl enable httpd

# Change to temporary directory
cd /tmp

# make dir for vivek_wesite and cd to it
mkdir vivek_website
cd vivek_website
git init
git clone https://github.com/viveksingh2511/edreamztask.git
cd edreamztask/


# Clean the default web root to avoid conflicts
rm -rf /var/www/html/*

# Copy contents to Apache web root
cp -r /tmp/vivek_website/edreamztask/* /var/www/html/


# Restart Apache to serve the new content
systemctl restart httpd
