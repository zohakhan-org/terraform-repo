output "role_arn" {
  description = "The arn of the user"
  value = aws_iam_user.iam_user.arn
}