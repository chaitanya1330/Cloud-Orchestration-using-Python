
variable "vpcCIDR" {
  default = "192.168.0.0/16"
}

variable "PublicSubnet1CIDR" {
  default = "192.168.0.0/24"
}

variable "PublicSubnet2CIDR" {
  default = "192.168.1.0/24"
}

variable "PrivateSubnet1CIDR" {
  default = "192.168.2.0/24"
}

variable "PrivateSubnet2CIDR" {
  default = "192.168.3.0/24"
}

variable "vpcName" {
  default = "terraform-VPC"
}

variable "PublicSubnet1Name" {
  default = "PublicSubnet1"
}

variable "PublicSubnet2Name" {
  default = "PublicSubnet2"
}

variable "PrivateSubnet1Name" {
  default = "PublicSubnet3"
}

variable InstanceTypeParameter{
  type        = string
  default     = "t2.micro"
  description = "Enter the type of instance"
}

variable "PrivateSubnet2Name" {
  default = "PublicSubnet4"
}
