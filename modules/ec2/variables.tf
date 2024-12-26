variable "aws_region" {
  description = "aws region"
  type        = string
}

variable "ec2_instance_name" {
  description = "Name of the EC2 instance"
  type = string
}

variable "ec2_instance_type" {
    description = "Type of the EC2 instance"
    type = string
}

variable "ec2_ami_id" {
    description = "AMI ID of the EC2 instance"
    type = string
}

variable "ec2_instance_count" {
  description = "Number of instances to create"
    type        = number
}
