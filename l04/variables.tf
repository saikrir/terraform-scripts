variable "my_tags" {
  type = map(string)
  default = {
    "Name"    = "MyApp"
    "Author"  = "Sai Katterishetty"
    "Project" = "Learning AWS Terraform"
  }
}


variable "region" {
  description = "Region"
  type        = string
  default     = "us-east-1"
}