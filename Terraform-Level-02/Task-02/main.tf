provider "aws" {
  region = "us-east-1" # Adjust region if needed based on your environment
}

# Create the private VPC
resource "aws_vpc" "nautilus_priv_vpc" {
  cidr_block           = var.KKE_VPC_CIDR
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "nautilus-priv-vpc"
  }
}

# Create the private subnet (auto-assign public IP is false by default)
resource "aws_subnet" "nautilus_priv_subnet" {
  vpc_id                  = aws_vpc.nautilus_priv_vpc.id
  cidr_block              = var.KKE_SUBNET_CIDR
  map_public_ip_on_launch = false

  tags = {
    Name = "nautilus-priv-subnet"
  }
}

# Create security group allowing access only from within the VPC CIDR
resource "aws_security_group" "nautilus_priv_sg" {
  name        = "nautilus-priv-sg"
  description = "Allow inbound traffic only from within the VPC"
  vpc_id      = aws_vpc.nautilus_priv_vpc.id

  ingress {
    description = "Allow all traffic from VPC CIDR"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.nautilus_priv_vpc.cidr_block]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nautilus-priv-sg"
  }
}

# Get latest Amazon Linux 2 AMI dynamically
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Create the EC2 instance inside the private subnet
resource "aws_instance" "nautilus_priv_ec2" {
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = "t2.micro"
  subnet_id            = aws_subnet.nautilus_priv_subnet.id
  vpc_security_group_ids = [aws_security_group.nautilus_priv_sg.id]

  tags = {
    Name = "nautilus-priv-ec2"
  }
}