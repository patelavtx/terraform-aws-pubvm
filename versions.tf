terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      #version = "~> 5.30.0"
      version = ">= 6.0"
    }
    http = {
      source  = "registry.terraform.io/hashicorp/http"
      version = "~> 3.0"
    }
  }
}
