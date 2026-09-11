data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "nautilus_ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "nautilus-ec2"
  }
}

resource "aws_eip" "nautilus_eip" {
  instance = aws_instance.nautilus_ec2.id
  domain   = "vpc"

  tags = {
    Name = "nautilus-eip"
  }
}