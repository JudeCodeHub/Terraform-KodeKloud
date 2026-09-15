
resource "aws_iam_user" "anita" {
  name = var.KKE_USER_NAME

  provisioner "local-exec" {
    command = "mkdir -p /home/bob/terraform && echo 'KKE ${var.KKE_USER_NAME} has been created successfully!' > /home/bob/terraform/KKE_user_created.log"
  }
}