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
    resources = ["arn:aws:iam::*:role/${var.iam_user_creation_policy_name}-Auto"]

  }
}

resource "aws_iam_user" "iam_user" {
  name="${var.iam_user_creation_user_prefix}.${var.iam_user_creation_policy_name}-${timestamp()}"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_iam_user_policy" "iam_user_policy" {
  name="inline-policy-${var.iam_user_creation_policy_name}"
  user=aws_iam_user.iam_user.name
  policy = data.aws_iam_policy_document.automation_assume_role_policy.json

}