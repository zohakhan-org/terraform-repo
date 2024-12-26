terraform {
  backend "s3" {
    bucket="tf-state-25tfs"
    key="development/terraform_state"
    region="us-east-1"
    encrypt        = true
  }
}
