output "KKE_instance_name" {
  value       = aws_instance.nautilus_ec2.tags["Name"]
  description = "The name of the EC2 instance"
}

output "KKE_eip" {
  value       = aws_eip.nautilus_eip.public_ip
  description = "The public Elastic IP address assigned to the instance"
}