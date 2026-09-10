variable "KKE_VPC_CIDR" {
  type        = string
  description = "CIDR block for the private VPC"
  default     = "10.0.0.0/16"
}

variable "KKE_SUBNET_CIDR" {
  type        = string
  description = "CIDR block for the private subnet"
  default     = "10.0.1.0/24"
}