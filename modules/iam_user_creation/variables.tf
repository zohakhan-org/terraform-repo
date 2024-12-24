variable "policy_name" {
  description = "This is name of the policy, the prefix of the role(it will be policy_name-Auto)"
  type = string
}

variable "policy_statements" {
  type = any
  description = "(Required. conflicts with policy) A list of policy statements to build the policy document from."
  default = []
}
variable "user_prefix" {
    description = "This is the prefix of the user name"
    type = string
  default = "user"
}

variable "aws_region" {
  description = "aws region"
  type = string
}