terraform {
  backend "s3-bucket" {
    bucket="tf-state-25tfs"
    key="development/terraform_state"
    region="us-east-1"
  }
}