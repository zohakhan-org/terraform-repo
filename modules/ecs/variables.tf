variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "ami" {
  description = "The AMI ID for ECS instances"
  type        = string
  default = "ami-0b0ea68c435eb488d"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "my-ecs-cluster"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default = "vpc-0e88381e6c4aa04f8"
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
  default = ["subnet-0cca8fd4378a176ff"]
}

variable "ecs_task_definition" {
  description = "The ECS task definition"
  type        = string
    default     = "container-definitions.json"
}

variable "ecs_service_name" {
  description = "ECS Service name"
  type        = string
  default     = "my-ecs-service"
}
