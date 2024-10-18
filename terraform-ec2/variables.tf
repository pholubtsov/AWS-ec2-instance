variable "region" {
  type        = string
  description = "AWS region to deploy resources"
}

variable "key_name" {
  type        = string
  description = "Name of the SSH key to use"
}

variable "public_key_path" {
  type        = string
  description = "Path to the public SSH key"
}

variable "security_group_name" {
  type        = string
  description = "Name of the security group"
}

variable "allowed_ip_ssh" {
  type        = string
  description = "CIDR block to allow SSH access"
}

variable "ami" {
  type        = string
  description = "AMI ID to use for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "Instance type for the EC2 instance"
}

variable "secret_name" {
  type        = string
  description = "Name of the secret in AWS Secrets Manager"
}
