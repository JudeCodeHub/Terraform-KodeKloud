resource "aws_cloudformation_stack" "nautilus_stack" {
  name          = "nautilus-dynamodb-stack"
  template_body = local.cf_template_body

  lifecycle {
    ignore_changes = [parameters]
  }
}