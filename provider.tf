terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }
}


provider "aws" {
  profile = "Chaitanya"
  region  = "ap-south-1"
  alias   = "ap-sou-1"
}
