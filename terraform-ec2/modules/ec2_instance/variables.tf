variable "ami" {
  type        = string
  description = "AMI ID for the instance"
}

variable "instance_type" {
  type        = string
  description = "Type of instance (e.g., t2.micro)"
}

variable "key_name" {
  type        = string
  description = "Name of the SSH key to use"
}

variable "security_group_id" {
  type        = string
  description = "ID of the security group"
}
