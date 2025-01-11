#!/bin/bash

# rhel8 or 9 used

sudo dnf install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo touch /var/www/html/index.html
sudo chmod 644 /var/www/html/index.html
echo "Hello World ASG Instance" | sudo tee -a /var/www/html/index.html

TOKEN=`sudo curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
echo $TOKEN
HOSTNAME=`sudo curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/tags/instance/Name`
echo $HOSTNAME
sudo hostnamectl set-hostname $HOSTNAME