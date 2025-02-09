set -e
exec > >(tee /var/log/user_data.log | logger -t user-data) 2>&1

#always update pcks first on linux
sudo apt-get update -y

#install apache, nginx would also suffice
sudo apt-get install -y apache2

#start apache
sudo systemctl start apache2
sudo systemctl enable apache2

#a joke of a html
echo "Hello, World!" > /var/www/html/index.html

#we will see if this works for health check, had a bug before with nat gateway for being able to download
echo "healthy" > /var/www/html/health

