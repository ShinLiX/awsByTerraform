output "public_ips" {
  description = "Public IPs of EC2 instances"
  value       = aws_instance.this[*].public_ip
}

output "private_ips" {
  description = "Private IPs of EC2 instances"
  value       = aws_instance.this[*].private_ip
}

output "public_dns" {
  description = "Public DNS names of EC2 instances"
  value       = aws_instance.this[*].public_dns
}

output "ssh_commands" {
  description = "SSH commands to connect to the instances"
  value = [
    for ip in aws_instance.this[*].public_ip :
    "ssh -i ${var.ssh_private_key_path} ubuntu@${ip}"
  ]
}