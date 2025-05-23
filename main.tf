terraform {

  # Configure remote backend to store Terraform state securely
  backend "s3" {
    # Name of the S3 bucket that stores the Terraform state file
    bucket = "s3-remote-backend-internship-maksym"

    # Path to the state file within the bucket
    key = "terraform.tfstate"

    # AWS region where the S3 bucket and DynamoDB table are located
    region = "eu-west-1"

    # Since Dynamo
    encrypt      = true
    use_lockfile = true
  }
}

module "networking" {
  source               = "./modules/networking"
  availability_zones   = var.availability_zones
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  vpc_cidr             = var.vpc_cidr
}

module "security" {
  source          = "./modules/security"
  alb_cidr_blocks = var.alb_allowed_cidrs
  vpc_id          = module.networking.vpc_id
}

module "iam" {
  source = "./modules/iam"
}

module "compute" {
  source               = "./modules/compute"
  ami_id               = var.ami_id
  iam_instance_profile = module.iam.instance_profile.name
  instance_type        = var.instance_type
  security_group_ids   = [module.security.ec2_sg_id]
  subnet_ids           = module.networking.private_subnet_ids
  user_data_file       = var.user_data_file
}

module "alb" {
  source              = "./modules/alb"
  public_subnet_ids   = module.networking.public_subnet_ids
  security_group_id   = module.security.alb_sg_id
  target_instance_ids = module.compute.instance_ids
  vpc_id              = module.networking.vpc_id
}

module "launch_template" {
  source           = "./modules/launch_template"
  user_data_file   = var.user_data_file
  ec2_sg_id        = module.security.ec2_sg_id
  ec2_profile_name = module.iam.instance_profile.name
}

module "autoscaling_group" {
  source                 = "./modules/autoscaling_group"
  subnet_ids             = module.networking.private_subnet_ids
  template_web_server_id = module.launch_template.launch_template_id
  lb_target_group_arns   = [module.alb.target_group_arn]
}

module "cloudwatch-agent" {
  source = "./modules/cloudwatch-agent"
}

module "monitoring" {
  source            = "./modules/monitoring"
  email_addresses   = var.email_addresses
  instance_ids      = module.compute.instance_ids
  asg_name          = module.autoscaling_group.asg_name
  alb_arn_suffix    = module.alb.alb_arn_suffix
  alb_tg_arn_suffix = module.alb.target_group_arn_suffix
}

module "logging" {
  source       = "./modules/logging"
  vpc_id       = module.networking.vpc_id
  iam_role_arn = module.iam.flow_logs_role_arn
}

module "config" {
  source = "./modules/config"
}
