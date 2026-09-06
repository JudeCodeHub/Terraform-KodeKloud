resource "aws_iam_policy" "iam_policy" {
  name        = var.KKE_iampolicy
  description = "IAM policy for anita"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ec2:Describe*"]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name = var.KKE_iampolicy
  }
}