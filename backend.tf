terraform {
  backend "s3" {
    bucket = "chaitanya1330"
    key    = "Terraform_State_File/terraform.tfstate"
    region = "ap-south-1"
  }
}
