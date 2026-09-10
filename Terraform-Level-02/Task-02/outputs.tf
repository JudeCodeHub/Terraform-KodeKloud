output "KKE_vpc_name" {
  value       = aws_vpc.nautilus_priv_vpc.tags["Name"]
  description = "Name of the VPC"
}

output "KKE_subnet_name" {
  value       = aws_subnet.nautilus_priv_subnet.tags["Name"]
  description = "Name of the subnet"
}

output "KKE_ec2_private" {
  value       = aws_instance.nautilus_priv_ec2.tags["Name"]
  description = "Name of the EC2 instance"
}