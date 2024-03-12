resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags                 = var.my_tags
}

resource "aws_subnet" "my_private_subnet" {
  cidr_block = var.private_subnet_cidr_block
  vpc_id     = aws_vpc.my_vpc.id
  tags       = var.my_tags
}

resource "aws_subnet" "my_public_subnet" {
  cidr_block              = var.public_subnet_cidr_block
  vpc_id                  = aws_vpc.my_vpc.id
  map_public_ip_on_launch = true
  tags                    = var.my_tags
}


resource "aws_eip" "my_elastic_ip" {
  domain = "vpc"
  tags   = var.my_tags
}

resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.my_elastic_ip.id
  subnet_id     = aws_subnet.my_public_subnet.id
  tags          = var.my_tags
}

resource "aws_internet_gateway" "my_ig" {
  vpc_id = aws_vpc.my_vpc.id
  tags   = var.my_tags
}

resource "aws_route_table" "my_vpc_public_rt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = var.any_ip_cidr_block
    gateway_id = aws_internet_gateway.my_ig.id
  }
  tags = var.my_tags
}

resource "aws_route_table" "my_vpc_private_rt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block     = var.any_ip_cidr_block
    nat_gateway_id = aws_nat_gateway.my_nat_gateway.id
  }
  tags = var.my_tags
}


resource "aws_security_group" "my_http_sg" {
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    cidr_blocks = var.any_cidr_blocks
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  egress {
    cidr_blocks = var.any_cidr_blocks
    from_port   = 0
    to_port     = 0
    protocol    = -1
  }

  tags = var.my_tags
}

resource "aws_security_group" "my_ssh_sg" {
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    cidr_blocks = var.any_cidr_blocks
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  egress {
    cidr_blocks = var.any_cidr_blocks
    from_port   = 0
    to_port     = 0
    protocol    = -1
  }

  tags = var.my_tags
}

resource "aws_route_table_association" "my_vpc_public_subnet_rt_assoc" {
  subnet_id      = aws_subnet.my_public_subnet.id
  route_table_id = aws_route_table.my_vpc_public_rt.id
}

resource "aws_route_table_association" "my_vpc_private_subnet_rt_assoc" {
  subnet_id      = aws_subnet.my_private_subnet.id
  route_table_id = aws_route_table.my_vpc_private_rt.id
}


data "aws_ssm_parameter" "amzn2_linux" {
  name = var.linux_image_path
}


resource "aws_instance" "my_public_aws_instance" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.my_public_subnet.id
  vpc_security_group_ids = [aws_security_group.my_http_sg.id, aws_security_group.my_ssh_sg.id]
  key_name               = var.key_name
  user_data              = file("${path.module}/${var.web_server_script}")
  tags                   = var.my_tags
}

resource "aws_instance" "my_private_aws_instance" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = "t2.micro"
  key_name               = var.key_name
  subnet_id              = aws_subnet.my_private_subnet.id
  vpc_security_group_ids = [aws_security_group.my_ssh_sg.id]
  tags                   = var.my_tags
}

resource "aws_key_pair" "my_aws_keypair" {
  key_name   = var.key_name
  public_key = var.my_public_key
}

