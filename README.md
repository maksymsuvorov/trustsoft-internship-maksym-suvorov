# Terraform AWS Infrastructure - Trustsoft Internship Project

# Project Overview

This project uses **Terraform** to provision an AWS environment, broken into logical modules for clarity and reuse.

---

# Architecture diagram
![Architecture diagram](./docs/diagram.png)

---
### 2.5.2025

## Networking

- **VPC** with public and private subnets across two AZs 
- **Internet Gateway** for public-facing traffic  
- **NAT Gateways** (one per AZ) to allow private EC2 instances outbound Internet access without public IPs  
- Route tables and associations connecting all pieces

### 1. Public Route Table (`public_subnet_rt`)

- **Associated with:**  
  - `public_subnet_1` (AZ‑1)  
  - `public_subnet_2` (AZ‑2)  

- **Routes:**  
  
| Destination   | Target             | Purpose                                         |
  |---------------|--------------------|-------------------------------------------------|
  | `0.0.0.0/0`   | Internet Gateway   | Allows inbound Internet traffic to ALB, NAT GWs |
  | `local`       | `–` (VPC router)   | Enables inside‑VPC communication                |

### 2. Private Route Table AZ‑1 (`private_subnet_rt_1`)

- **Associated with:**  
  - `private_subnet_1` (AZ‑1)  

- **Routes:**  

  | Destination   | Target                         | Purpose                                        |
  |---------------|--------------------------------|------------------------------------------------|
  | `0.0.0.0/0`   | NAT Gateway 1 (`nat_gw_1`)     | Allows EC2 in private subnet to reach Internet |
  | `local`       | `–` (VPC router)               | Enables inside‑VPC communication               |

### 3. Private Route Table AZ‑2 (`private_subnet_rt_2`)

- **Associated with:**  
  - `private_subnet_2` (AZ‑2)  

- **Routes:**

  | Destination   | Target                         | Purpose                                        |
  |---------------|--------------------------------|------------------------------------------------|
  | `0.0.0.0/0`   | NAT Gateway 2 (`nat_gw_2`)     | Allows EC2 in private subnet to reach Internet |
  | `local`       | `–` (VPC router)               | Enables inside‑VPC communication               |


---

## Security

- **Security Groups**  
  - ALB SG: allows HTTP from the Internet  
  - EC2 SG: allows HTTP only from the ALB  
- **IAM Role** + **Instance Profile**  
  - Grants EC2 instances permission for **SSM Session Manager** (no SSH keys needed)

---

## Compute & Load Balancing

- Two **EC2** instances in different private subnets  
  - Bootstrapped via `user_data` to install Web Server and register with SSM  
- An **Application Load Balancer** in public subnets  
  - Distributes HTTP traffic to EC2 instances  
  - Performs health checks on a `/` endpoint
- **Target Group**
  - Defines which backend targets receive traffic
---

## Monitoring

- **CloudWatch Agent** on EC2 for logs and custom metrics  
- **CloudWatch Alarms** monitoring CPU utilization  
- **SNS Topic** for email alerts to a configurable list of recipients

---

## Remote backend
- Remote state stored in **S3** (with versioning and SSE-KMS encryption)  
- State locking **without DynamoDB** using S3 native locking

### 5.5.2025

## VPC Flow Logs into CloudWatch
- Enabled VPC Flow Logs for the entire VPC.
- CloudWatch Logs group with a retention period set to **3 days**.

## EC2 CloudWatch Agent
- Installed CloudWatch Agent on EC2 instances via SSM.
- Monitored Metrics: `mem_used_percent`, `disk_used_percent`
- Config stored in **SSM Parameter Store**
- Installed via **SSM Document** + **Association**

## EC2 Status Check Alarm
- Ensures the instance is healthy on OS level.
- **Configured** similarly to other alarms with SNS alerting.

## AWS Config Rule – Required Tags
-  Enforce consistent tagging, applied on the two EC2 instances.
- Tags enforced: `Name`

### 6.5.2025

## Task 1:
> The customer is complaining that the server has high CPU usage. Try to determine what is causing the load and eliminate the problem 

- After this problem occurred, the CPU metrics monitored via CloudWatch have risen.

![CPU Usage](./docs/opts-screenshots/cpu-usage.png)

- Using `ps aux --sort=-%cpu` command I discovered that someone has run `yes` command in terminal.

![Yes command](./docs/opts-screenshots/yes.png)

- My first idea was to kill this procces using `kill -9 <pid>` command. Unfortunately, right after killing the process, there was started the same command with another process ID.
- Some script was running this program. Using `ps -o pid,ppid,cmd -p <id>` I have found this script and deleted it.

![Yes command](./docs/opts-screenshots/ps-1.png)
![Yes command](./docs/opts-screenshots/ps-2.png)

- After an hour, it was created again. So the issue was somewhere else. There was some kind of backdoor that was enabling deamon, which was starting this script or uploading it on the EC2 instance.
- It occurred that there was a python script, named `health-check`, that was starting (uploading) the script.

![Python script](./docs/opts-screenshots/python-script.png)

- After I deleted it and disabled all related services, the problem was solved.

## Task 2:
> A customer complains that his application is not running on the server and that he cannot connect to it. Try to figure out why and fix it as follows

- After this problem has occurred, I could not connect to the EC2 instance via SSM. I used an AWS EC2 feature and displayed an instance screenshot.

![Instance screenshot](./docs/opts-screenshots/instance-screenshot.png)

- The root account was disabled and I could not log in into account.
- To find the origin of this problem, I needed the access to the instance disk.
- So I created a snapshot of the instance disk via AWS console and created a new value using this snapshot. 
- Then I have created a new EC2 instance (in the same AZ used by the damaged instance) using the new volume. After mounting the new volume to the new EC2 instance's FS, I was trying to find what was causing the problem.
- It turned out, that the problem was in the `etc/fstub` file.
- The content of the file was
```
UUID=b1e84820-06b0-4d3b-9b5d-edd836bd5895 / xfs defaults,noatime 1 1
UUID=b1e84820-06b0-4d3b-9b5d-edd836bd5895 / xfs defaults,noatime 1 1
UUID=DED7-C018 /boot/efi vfat defaults,noatime,uid=0,gid=0,umask=0077,shortname=winnt,x-systemd.automount 0 2
UUID=11111111-2222-3333-4444-555555555555 /mnt/kaput xfs defaults 0 2
```

- The first issue was that someone has mounted the same UUID twice to `/`, which is invalid and will cause boot failures.
- The second issue was that `mnt/kaput` does not exist in the system.
- After deleting the first and the last rows, I have unmounted the disk from the helper EC2 instance and attached it to the damaged instance.
- The problem was solved.

---

## IaC
```
├── backend.tf                # Remote backend configuration (S3 + DynamoDB)
├── versions.tf               # Terraform & provider version constraints
├── variables.tf              # Root-module input variable definitions
├── outputs.tf                # Root-module outputs that expose module results
├── main.tf                   # Calls all child modules
├── bootstrap/                # Create backend infrastructure (S3 bucket, DynamoDB, KMS)
│   └── backend-setup.tf      # Resources for S3, DynamoDB, KMS key
├── modules/                  # Reusable modules, each with its own variables/outputs
│   ├── networking/           # Module for VPC, subnets, IGW, NAT, route tables
│   │   ├── main.tf           
│   │   ├── variables.tf      # Inputs: vpc_cidr, subnet CIDRs, AZs
│   │   └── outputs.tf        # Outputs: vpc_id, subnet IDs, igw_id, nat_gw_ids, rt_ids
│   ├── security/             # Module for security groups (ALB & EC2)
│   │   ├── main.tf
│   │   ├── variables.tf      # Inputs: vpc_id, alb_cidr_blocks
│   │   └── outputs.tf        # Outputs: alb_sg_id, ec2_sg_id
│   ├── iam/                  # Module for IAM roles & instance profiles
│   │   ├── main.tf
│   │   ├── variables.tf      
│   │   └── outputs.tf        # Outputs: role_arn, instance_profile
│   ├── compute/              # Module for EC2 instances
│   │   ├── main.tf
│   │   ├── variables.tf      # Inputs: ami_id, instance_type, subnet_ids, SGs, iam_instance_profile, user_data_file
│   │   └── outputs.tf        # Outputs: instance_ids, private_ips
│   ├── alb/                  # Module for Application Load Balancer & target group
│   │   ├── main.tf
│   │   ├── variables.tf      # Inputs: vpc_id, public_subnet_ids, security_group_id, target_ids
│   │   └── outputs.tf        # Outputs: alb_dns_name, target_group_arn
│   ├── logging/              # Module for logging setup
│   │   ├── main.tf
│   │   ├── variables.tf      # Inputs: vpc_id, iam_role_arn
│   │   └── outputs.tf        
│   ├── config/               # Module for infrastructure configuration
│   │   ├── main.tf
│   │   ├── variables.tf      
│   │   └── outputs.tf        # Outputs: config_rule_name, config_rule_id, config_rule_arn, config_rule_description
│   ├── cloudwatch-agent/     # Module for CloudWatch modulestup
│   │   ├── main.tf
│   │   ├── variables.tf      
│   │   └── outputs.tf        # Outputs: cloudwatch_ssm_parameter_name, cloudwatch_ssm_document_name, cloudwatch_ssm_association_id
│   └── monitoring/           # Module for CloudWatch alarms & SNS notifications
│       ├── main.tf
│       ├── variables.tf      # Inputs: instance_ids, email_addresses
│       └── outputs.tf        # Outputs: sns_topic_arn
├── scripts/                  # Helper scripts and user_data files
└────── userdata.sh           # Bootstraps EC2 with Web Server and   SSM
```

---

# Deploying
```
terraform init     # Initializes working directory
terraform plan     # Shows what will be created
terraform apply    # Deploys resources
```

> **Warning: Create a backend before deploying! Go to the `bootstrap/` folder and do the same steps.**

---

# Cleaning Up
```
terraform destroy
```

---


# Documentation generated using [terraform-docs](https://terraform-docs.io/).

> **Each module has its own documentation within its folder generated via [terraform-docs](https://terraform-docs.io/).**

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.81 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | ./modules/alb | n/a |
| <a name="module_compute"></a> [compute](#module\_compute) | ./modules/compute | n/a |
| <a name="module_config"></a> [config](#module\_config) | ./modules/config | n/a |
| <a name="module_iam"></a> [iam](#module\_iam) | ./modules/iam | n/a |
| <a name="module_logging"></a> [logging](#module\_logging) | ./modules/logging | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_networking"></a> [networking](#module\_networking) | ./modules/networking | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_allowed_cidrs"></a> [alb\_allowed\_cidrs](#input\_alb\_allowed\_cidrs) | List of CIDR blocks permitted to connect to the ALB | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | AMI ID to use for EC2 instances | `string` | `"ami-0ce8c2b29fcc8a346"` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of Availability Zones to distribute subnets and NAT Gateways | `list(string)` | <pre>[<br/>  "eu-west-1a",<br/>  "eu-west-1b"<br/>]</pre> | no |
| <a name="input_backend_bucket"></a> [backend\_bucket](#input\_backend\_bucket) | Name of the S3 bucket used to store Terraform state | `string` | `"s3-remote-backend-internship-maksym"` | no |
| <a name="input_backend_dynamodb_table"></a> [backend\_dynamodb\_table](#input\_backend\_dynamodb\_table) | Name of the DynamoDB table used for Terraform state locking | `string` | `"dynamodb-state-lock-table-internship-maksym"` | no |
| <a name="input_email_addresses"></a> [email\_addresses](#input\_email\_addresses) | List of email addresses to receive CloudWatch alarm notifications | `list(string)` | <pre>[<br/>  "maksym.suvorov@trustsoft.eu"<br/>]</pre> | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EC2 instance type | `string` | `"t2.micro"` | no |
| <a name="input_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#input\_private\_subnet\_cidrs) | List of CIDR blocks for private subnets | `list(string)` | <pre>[<br/>  "10.0.11.0/24",<br/>  "10.0.12.0/24"<br/>]</pre> | no |
| <a name="input_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#input\_public\_subnet\_cidrs) | List of CIDR blocks for public subnets | `list(string)` | <pre>[<br/>  "10.0.1.0/24",<br/>  "10.0.2.0/24"<br/>]</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region where all resources will be created | `string` | `"eu-west-1"` | no |
| <a name="input_user_data_file"></a> [user\_data\_file](#input\_user\_data\_file) | Path to the bootstrap script for EC2 | `string` | `"scripts/userdata.sh"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | DNS name of the Application Load Balancer |
| <a name="output_alb_sg_id"></a> [alb\_sg\_id](#output\_alb\_sg\_id) | Security Group ID for the Application Load Balancer |
| <a name="output_ec2_role_arn"></a> [ec2\_role\_arn](#output\_ec2\_role\_arn) | ARN of the IAM role for EC2 instances |
| <a name="output_ec2_sg_id"></a> [ec2\_sg\_id](#output\_ec2\_sg\_id) | Security Group ID for EC2 instances |
| <a name="output_flow_logs_role_arn"></a> [flow\_logs\_role\_arn](#output\_flow\_logs\_role\_arn) | ARN of the IAM role for flow logs |
| <a name="output_instance_ids"></a> [instance\_ids](#output\_instance\_ids) | List of EC2 instance IDs |
| <a name="output_instance_ips"></a> [instance\_ips](#output\_instance\_ips) | List of EC2 instance IPs |
| <a name="output_instance_profile"></a> [instance\_profile](#output\_instance\_profile) | Name of the IAM Instance Profile attached to EC2 |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | ID of the Internet Gateway |
| <a name="output_nat_gateway_ids"></a> [nat\_gateway\_ids](#output\_nat\_gateway\_ids) | List of NAT Gateway IDs |
| <a name="output_private_ips"></a> [private\_ips](#output\_private\_ips) | Private IP addresses of the EC2 instances |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | List of private subnet IDs |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | List of public subnet IDs |
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | ARN of the SNS topic for CloudWatch alerts |
| <a name="output_target_group_arn"></a> [target\_group\_arn](#output\_target\_group\_arn) | ARN of the ALB target group |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of the created VPC |
