variable "iam_roles" {
  type = list(object({
    name     = string
    policies = list(string)
  }))
}

variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "iam_groups" {
  type = list(object({
    name     = string
    policies = list(string)
  }))
}
