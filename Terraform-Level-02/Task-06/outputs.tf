output "KKE_ami_id" {
  value = aws_ami_from_instance.xfusion_ami.id
}

output "KKE_new_instance_id" {
  value = aws_instance.xfusion_new.id
}