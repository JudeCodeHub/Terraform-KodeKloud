provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "nautilus" {
  count         = var.KKE_INSTANCE_COUNT
  ami           = local.AMI_ID
  instance_type = var.KKE_INSTANCE_TYPE
  key_name      = var.KKE_KEY_NAME

  tags = {
    Name = "${var.KKE_INSTANCE_PREFIX}-${count.index + 1}"
  }
}