data "aws_iam_policy_document" "assume_role_policy" {
  for_each = { for role in var.iam_roles : role.name => role }

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"] # Adjust as needed
    }
  }
}
