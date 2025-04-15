provider "aws" {
  region = local.region
}

terraform {

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~>5.49"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~>1.14.0"
    }
  }
}

