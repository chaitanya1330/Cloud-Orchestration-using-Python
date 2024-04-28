terraform {
  backend "s3" {
    bucket = "haribucket775"
    key    = "Terraform_State_File/terraform.tfstate"
    region = "ap-south-1"
  }
}
