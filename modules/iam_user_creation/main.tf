data "aws_iam_policy_document" "automation_assume_role_policy" {
  dynamic "statement" {
    for_each = var.policy_statements
    content {
      effect = try(statement.value.effect, null)
      actions = try(statement.value.actions, null)
      resources = try(statement.value.resources, null)
    }
  }
  statement {
    actions = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::*:role/${var.policy_name}-Auto"]

  }
}

resource "aws_iam_user" "iam_user" {
  name="${var.user_prefix}.${var.policy_name}"

}

resource "aws_iam_user_policy" "iam_user_policy" {
  name="inline-policy-${var.policy_name}"
  user=aws_iam_user.iam_user.name
  policy = data.aws_iam_policy_document.automation_assume_role_policy.json
}