output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.cloudops_ec2.id
}

output "instance_public_ip" {
  description = "EC2 public IP address"
  value       = aws_instance.cloudops_ec2.public_ip
}