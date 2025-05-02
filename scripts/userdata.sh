#!/bin/bash
yum update -y

yum install -y amazon-ssm-agent
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

yum install -y httpd

echo "<h1>Hello from EC2 instance $(hostname)</h1>" > /var/www/html/index.html

systemctl enable httpd
systemctl start httpd

