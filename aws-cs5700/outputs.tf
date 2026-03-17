output "public_ip" {
  description = "EC2 public IP"
  value       = aws_instance.this.public_ip
}

output "public_dns" {
  description = "EC2 public DNS"
  value       = aws_instance.this.public_dns
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ${var.ssh_private_key_path} ubuntu@${aws_instance.this.public_ip}"
}
