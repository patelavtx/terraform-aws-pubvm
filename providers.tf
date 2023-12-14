terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    http = {
      source  = "registry.terraform.io/hashicorp/http"
      version = "~> 3.0"
    }
  }
}