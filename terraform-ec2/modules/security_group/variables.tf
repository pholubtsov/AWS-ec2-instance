variable "security_group_name" {
  type        = string
  description = "Name of the security group"
}

variable "allowed_ip_ssh" {
  type        = string
  description = "CIDR block allowed for SSH access"
}
