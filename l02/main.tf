terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.20"
    }
  }
  required_version = ">= 1.2.0"
}


provider "aws" {
  region = "us-east-2"
}


data "aws_ssm_parameter" "ami" {
      name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


output "instance"  {
  value = "ssh -i keys/aws-keys ec2-user@${aws_instance.my_linux_instance.public_ip}"
}

resource "aws_instance" "my_linux_instance" {
  ami = data.aws_ssm_parameter.ami.value
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_ssh.id]
  key_name = "aws_key"
  tags = {
    name = "MyLinuxInstance"
  }
}



resource "aws_security_group" "sg_ssh" {
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
}



resource "aws_key_pair" "my_key_pair" {
  key_name = "aws_key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOcuBIlA9P+OtCl0BjfASOk5Q8i/YvwuCi6fu6FADnVx skrao@skrao-lin-ws-17"
}

