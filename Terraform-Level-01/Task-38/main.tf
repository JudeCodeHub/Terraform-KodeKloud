resource "aws_iam_user" "iam_user" {
  name = var.KKE_user

  tags = {
    Name = var.KKE_user
  }
}