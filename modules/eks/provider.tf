provider "aws" {
  region = var.aws_region
  version = "~> 5.46"
}

data "aws_region" "current" {
}

data "aws_availability_zones" "available" {
}

provider "http" {
}
