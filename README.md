# Terraform AWS Infostructure - Trustsoft Internship Project

# Overview
This project deploys a basic AWS infrastructure using Terraform:

- VPC with 2 public and 2 private subnets
- 2 EC2 instances in private subnets with ALB
- IAM role with SSM access
- NAT Gateway and Internet Gateway
- Encrypted S3 remote backend with KMS
- CloudWatch monitoring and alarms via email

# Architecture diagram
![Architecture diagram](./diagram.png)

# File and folder structure
- `provider.tf` — contains information about provider
- `variables.tf` — definition of variables used in this project
- `bootstrap/backend-setup.tf` — remote backend implementation using S3 bucket and DynamoDB
- `scripts/userdata.sh` — user-data script used by EC2 instances
- `vpc.tf` — VPC, subnets, routing, NAT
- `backend.tf` — definition of backend used in this project
- `security_groups.tf` — security groups of ALB and EC2 instances
- `iam.tf` — IAM roles and instance profile
- `alb.tf` — load balancer, target groups
- `ec2.tf` — EC2 instances
- `cpu_metric_alarm.tf` — CloudWatch alarms

# Description of Used Services in this Project

# Deploying
```
terraform init     # Initializes backend
terraform plan     # Shows what will be created
terraform apply    # Deploys resources
```


# Clean Up
```
terraform destroy
```
