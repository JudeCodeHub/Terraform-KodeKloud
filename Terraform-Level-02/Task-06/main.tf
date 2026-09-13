resource "aws_instance" "ec2" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    "sg-37bfa1b6ef0fc3e96"
  ]
  tags = {
    Name = "xfusion-ec2"
  }
}

resource "aws_ami_from_instance" "xfusion_ami" {
  name               = "xfusion-ec2-ami"
  source_instance_id = aws_instance.ec2.id
}

resource "aws_instance" "xfusion_new" {
  ami           = aws_ami_from_instance.xfusion_ami.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    "sg-37bfa1b6ef0fc3e96"
  ]
  tags = {
    Name = "xfusion-ec2-new"
  }
}