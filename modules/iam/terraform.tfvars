aws_region = "us-east-1"
iam_roles = [{"name":"AppAdminRole","policies":["arn:aws:iam::aws:policy/AdministratorAccess"]},{"name":"ReadOnlyRole","policies":["arn:aws:iam::aws:policy/ReadOnlyAccess"]}]
iam_groups = [{"name":"AdminGroup","policies":["arn:aws:iam::aws:policy/AdministratorAccess"]},{"name":"ReadOnlyGroup","policies":["arn:aws:iam::aws:policy/ReadOnlyAccess"]}]
