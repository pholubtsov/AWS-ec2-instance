# --- IAM Role Creation for EC2 Instance ---
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Effect": "Allow",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          }
        }
      ]
    }
  EOF
}

# --- IAM Policy for Secrets Manager Access ---
resource "aws_iam_policy" "secrets_manager_policy" {
  name = "secrets_manager_policy"

  policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
            "secretsmanager:GetSecretValue"
          ],
          "Effect": "Allow",
          "Resource": "*"
        }
      ]
    }
  EOF
}

# --- Attach the Secrets Manager Policy to the EC2 Role ---
resource "aws_iam_role_policy_attachment" "attach_secrets_manager_policy" {
  role       = aws_iam_role.ec2_role.name 
  policy_arn = aws_iam_policy.secrets_manager_policy.arn 
}

# --- IAM Instance Profile Creation ---
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

# --- EC2 Instance Creation ---
resource "aws_instance" "my_tf_ubuntu_instance" {
  ami               = var.ami
  instance_type     = var.instance_type
  key_name          = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get upgrade -y
              sudo apt-get install ca-certificates curl jq awscli -y
              sudo install -m 0755 -d /etc/apt/keyrings
              sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
              sudo chmod a+r /etc/apt/keyrings/docker.asc
              echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
              sudo apt-get update -y
              sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

              SECRET_VALUE=$(aws secretsmanager get-secret-value --region ${var.region} --secret-id ${var.secret_arn} --query SecretString --output text)
              echo "MY_SECRET_KEY=$SECRET_VALUE" > /home/ubuntu/.env
              EOF

  associate_public_ip_address = true

  tags = {
    Name = "MyUbuntuInstance"
  }
}

# --- Outputs ---
output "instance_public_ip" {
  value = aws_instance.my_tf_ubuntu_instance.public_ip
}
