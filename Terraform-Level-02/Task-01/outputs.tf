output "kke_vpc_name" {
  value       = aws_vpc.main.tags["Name"]
  description = "The name of the VPC"
}

output "kke_subnet_name" {
  value       = aws_subnet.main.tags["Name"]
  description = "The name of the Subnet"
}