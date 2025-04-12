#!/bin/bash
# set -e
# exec > >(tee /var/log/user_data.log | logger -t user-data) 2>&1

#always update packages first on linux
sudo apt-get update -y

#install nginx
sudo apt-get install -y nginx

sudo systemctl enable nginx
sudo systemctl start nginx

echo "<html>Hello, Nginx! We are live from the static website! </html>" | sudo tee /var/www/html/index.html

echo "healthy" | sudo tee /var/www/html/health.html
