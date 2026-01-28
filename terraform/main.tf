terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  backend "s3" {
    bucket       = "jeeps3-remote-state260126"
    key          = "infrastructure/ap-southeast-1/terraform.tfstate"
    region       = "ap-southeast-1"
    use_lockfile = true
  }
}