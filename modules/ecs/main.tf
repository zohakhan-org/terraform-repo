# Create ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

# Create an ECS task definition
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "my-task-family"
  container_definitions    = file("container-definitions.json")
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"
}

# Create EC2 instances for ECS cluster (using ami and instance_type)
resource "aws_instance" "ecs_instance" {
  ami           = var.ami
  instance_type = var.instance_type

  # ECS-related configurations
  tags = {
    Name = "ECSInstance"
  }

  security_groups = [aws_security_group.ecs_sg.name]
  subnet_id       = element(var.subnet_ids, 0)  # You can select a specific subnet
}

# Create ECS Security Group
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Security group for ECS instances"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "ecs_service" {
  name            = "my-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 1

  deployment_configuration {
    minimum_healthy_percent = 100
    maximum_percent         = 200
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.example.arn
    container_name   = "my-container"
    container_port   = 80
  }

  tags = {
    Name = "my-ecs-service"
  }
}

# Create an IAM role for ECS instances
resource "aws_iam_role" "ecs_instance_role" {
  name = "ecsInstanceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      },
    ]
  })
}

# Attach policies to the ECS instance role
resource "aws_iam_role_policy_attachment" "ecs_instance_policy" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_lb_target_group" "example" {
  name        = "my-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "vpc-0e88381e6c4aa04f8"
  target_type = "ip"
}
