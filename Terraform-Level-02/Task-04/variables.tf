variable "KKE_INSTANCE_COUNT" {
  type    = number
  default = 3
}

variable "KKE_INSTANCE_TYPE" {
  type    = string
  default = "t2.micro"
}

variable "KKE_KEY_NAME" {
  type    = string
  default = "nautilus-key"
}

variable "KKE_INSTANCE_PREFIX" {
  type    = string
  default = "nautilus-instance"
}