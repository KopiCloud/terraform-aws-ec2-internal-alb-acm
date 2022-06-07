################################
## AWS Provider Module - Main ##
################################

terraform {
  required_providers {

    # AWS Provider
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }

    # Let's Encrypt Provider
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.9"
    }
  }
}

# AWS Provider Credentials
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

# Let's Encrypt Provider Credentials
provider "acme" {
  server_url = var.let_encrypt_url
}