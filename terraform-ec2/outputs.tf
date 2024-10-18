output "instance_public_ip" {
  value       = module.ec2_instance.instance_public_ip
  description = "Public IP of the EC2 instance"
}

output "aws_account_name" {
  value       = data.aws_caller_identity.current.account_id
  description = "AWS Account Name"
}
