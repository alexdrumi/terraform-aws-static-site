#!/bin/bash
set -e
exec > >(tee /var/log/user_data.log | logger -t user-data) 2>&1

# Update packages
sudo apt-get update -y

# Install Apache
sudo apt-get install -y apache2

# Start Apache service
sudo systemctl start apache2
sudo systemctl enable apache2

# Set up a basic webpage
echo "Hello, World!" > /var/www/html/index.html

# Set up a health check
echo "healthy" > /var/www/html/health
