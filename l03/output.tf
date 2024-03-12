output "aws_instance_public_dns" {
  value       = "http://${aws_instance.my_public_aws_instance.public_dns}"
  description = "Public DNS for EC2 instance"
}


output "ec2_public_ssh" {
  value       = "ssh -i ${var.private_key_path} ec2-user@${aws_instance.my_public_aws_instance.public_ip}"
  description = "SSH entry into Public"
}

output "ec2_private_ssh" {
  value       = "ssh -i ${var.private_key_path} ec2-user@${aws_instance.my_private_aws_instance.private_ip}"
  description = "SSH entry into private EC2"
}


