#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Install Apache HTTP Server, wget, and unzip
yum install -y httpd wget unzip

# Start and enable Apache to run on boot
systemctl start httpd
systemctl enable httpd

# Change to temporary directory
cd /tmp

# Download the template ZIP
wget https://www.tooplate.com/zip-templates/2098_health.zip

# Unzip the file
unzip 2098_health.zip

# have a copy of data for backup from tmp dir to root dir (optional)
cp -r /tmp/2098_health/* /root/

# Clean the default web root to avoid conflicts
rm -rf /var/www/html/*

# Copy contents to Apache web root
cp -r 2098_health/* /var/www/html/

# Set proper permissions (optional but recommended)
#chown -R apache:apache /var/www/html
#chmod -R 755 /var/www/html

# Restart Apache to serve the new content
systemctl restart httpd


#vi /etc/fstab/
#/dev/xvdf1      /var/www/html/images ext4       defaults        0 0
#mkdir /var/lib/mysql/
#    2  ss -tunlp | grep 5593-
#    5  fdisk -l--
#    6  df -h--
#    9  mkdir /tmp/backup-images-
#   10  ls /tmp/
#   11  clear
#   12  ls
#   13  ls /tmp/
#   14  cp -r /tmp/2131_wedding_lite /root/
#   15  ls
#   16  clear
#   17  fdsik -l
#   18  clear
#   19  fdisk -l
#   20  fdisk /dev/xvdf
#   21  fdisk -l
#   22  mkfs.ext4 /dev/xvdf1
#   23  clear
#   24  ls /var/www/html/images/
#   25  ls /tmp/backup-images/
#   26  mv /var/www/html/images/* /tmp/backup-images/
#   27  ls /var/www/html/images/
#   28  mount /dev/xvdf1 /var/www/html/images
#   29  df -h
#   30  mv /tmp/backup-images/* /var/www/html/images/
#   31  systemctl status httpd
#   32  systemctl restart httpd
#   33  umount /var/www/html/images
#   34  vi /etc/fstab
#   35  clear
#   36  fdisk -l
#   37  df -h
#   38  mount -a
#   39  df -h
#   40  clear
#   41  systemctl restart httpd
#   42  systemctl status httpd
#   43  clear
#   44  reboot
#   45  df -h
#   46  history
