resource "aws_eip" "datacenter_eip" {
  domain = "vpc"

  tags = {
    Name = var.KKE_eip
  }
}

