terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

##################

provider "aws" {
  region  = "eu-central-1"
  profile = "admin"
}

##################

resource "aws_key_pair" "my_ssh_key" {
  key_name   = "my_ssh_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

##################

resource "aws_security_group" "instance_sg" {
  name          = "instance_sg"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["46.182.85.66/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##################

resource "aws_instance" "my_tf_ubuntu_instance" {
  ami           = "ami-09b54ba4514d9f6d8"
  instance_type = "t2.micro"

  key_name = aws_key_pair.my_ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get upgrade -y
              sudo apt-get install ca-certificates curl -y
              sudo install -m 0755 -d /etc/apt/keyrings
              sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
              sudo chmod a+r /etc/apt/keyrings/docker.asc
              echo \
                "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
                $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
                sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
              sudo apt-get update -y
              sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
              EOF

  associate_public_ip_address = true

  tags = {
    Name = "MyUbuntuInstance"
  }
}

##################

output "instance_public_ip" {
  value = aws_instance.my_tf_ubuntu_instance.public_ip
}