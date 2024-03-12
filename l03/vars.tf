variable "my_tags" {
  type = map(string)
  default = {
    "Name"    = "MyApp"
    "Author"  = "Sai Katterishetty"
    "Project" = "Learning AWS Terraform"
  }
}


variable "web_server_script" {
  type        = string
  description = "Description of where the WebSever Script lives"
  default     = "web_server.sh"
}


variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnet_cidr_block" {
  type    = string
  default = "10.0.1.0/24"
}


variable "public_subnet_cidr_block" {
  type    = string
  default = "10.0.2.0/24"
}

variable "any_ip_cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}

variable "linux_image_path" {
  type        = string
  description = "Linux Image to use"
}

variable "my_public_key" {
  type        = string
  description = "Public key to be copied"
}

variable "any_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}


variable "key_name" {
  type    = string
  default = "aws_key"
}

variable "region" {
  type    = string
  default = "us-east-2"
}

variable "private_key_path" {
  type        = string
  description = "Path to private key"
}
