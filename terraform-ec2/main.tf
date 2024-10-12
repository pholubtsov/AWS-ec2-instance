# Configure the AWS provider
provider "aws" {
  region  = var.region
  profile = "admin"
}

# AWS caller identity to retrieve the account ID
data "aws_caller_identity" "current" {}

# Call the SSH key module
module "ssh_key" {
  source         = "./modules/key_pair"
  key_name       = var.key_name
  public_key_path = var.public_key_path
}

# Call the security group module
module "security_group" {
  source              = "./modules/security_group"
  security_group_name = var.security_group_name
  allowed_ip_ssh      = var.allowed_ip_ssh
}

# Call the EC2 instance module
module "ec2_instance" {
  source                 = "./modules/ec2_instance"
  region                 = var.region
  ami                    = var.ami
  instance_type          = var.instance_type
  secret_arn             = module.secrets_manager.secret_arn
  key_name               = module.ssh_key.key_name
  security_group_id      = module.security_group.security_group_id
}

# Call the Secrets Manager module
module "secrets_manager" {
  source = "./modules/secrets_manager"
  secret_name = var.secret_name
}