resource "aws_security_group" "datacenter_sg" {
  name        = var.KKE_sg
  description = "Security Group provisioned for datacenter"

  tags = {
    Name = var.KKE_sg
  }
}