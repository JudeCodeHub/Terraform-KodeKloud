resource "aws_s3_bucket" "nautilus_logs" {
  bucket = var.KKE_BUCKET_NAME
}

resource "aws_iam_role" "nautilus_role" {
  name = var.KKE_ROLE_NAME

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "nautilus_access_policy" {
  name = var.KKE_POLICY_NAME

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.nautilus_logs.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "nautilus_policy_attachment" {
  role       = aws_iam_role.nautilus_role.name
  policy_arn = aws_iam_policy.nautilus_access_policy.arn
}

resource "aws_iam_instance_profile" "nautilus_profile" {
  name = "nautilus-instance-profile"
  role = aws_iam_role.nautilus_role.name
}

resource "aws_instance" "nautilus_ec2" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_instance_profile.nautilus_profile.name

  tags = {
    Name = "nautilus-ec2"
  }
}