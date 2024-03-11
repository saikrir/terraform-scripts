terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.36"
    }
  }
  required_version = ">= 1.5.0"
}


provider "aws" {
  region = "us-east-2"
}


resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "my_vpc"
  }
}

resource "aws_subnet" "my_private_subnet" {
  cidr_block = "10.0.1.0/24"
  vpc_id     = aws_vpc.my_vpc.id
  tags = {
    Name = "my_vpc_private_subnet"
  }
}

resource "aws_subnet" "my_public_subnet" {
  cidr_block              = "10.0.2.0/24"
  vpc_id                  = aws_vpc.my_vpc.id
  map_public_ip_on_launch = true
  tags = {
    Name = "my_vpc_public_subnet"
  }
}


resource "aws_internet_gateway" "my_ig" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_ig"
  }
}

resource "aws_route_table" "my_vpc_public_rt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_ig.id
  }
  tags = {
    Name = "my_vpc_public_rt"
  }
}


resource "aws_security_group" "my_http_sg" {
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = -1
  }

  tags = {
    Name = "my_http_sg"
  }
}

resource "aws_security_group" "my_ssh_sg" {
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = -1
  }

  tags = {
    Name = "my_ssh_sg"
  }
}

resource "aws_route_table_association" "my_vpc_public_subnet_rt_assoc" {
  subnet_id      = aws_subnet.my_public_subnet.id
  route_table_id = aws_route_table.my_vpc_public_rt.id
}

data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "my_public_aws_instance" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.my_public_subnet.id
  vpc_security_group_ids = [aws_security_group.my_http_sg.id, aws_security_group.my_ssh_sg.id]
  user_data              = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo '<html><head><title>Taco Team Server</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">Sai Katterishetty Loves &#127790; and AWS </span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html
EOF
  tags = {
    Name = "my_public_aws_instance"
  }
}

resource "aws_instance" "my_private_aws_instance" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.my_private_subnet.id
  vpc_security_group_ids = [aws_security_group.my_ssh_sg.id]
  tags = {
    Name = "my_private_aws_instance"
  }
}

output "aws_instance_public_dns" {
  value       = "http://${aws_instance.my_public_aws_instance.public_dns}"
  description = "Public DNS for EC2 instance"
}

