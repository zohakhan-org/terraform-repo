variable "aws_region" {
  description = "aws region"
  type        = string
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type = string
}

variable "instance_type" {
    description = "Type of the EC2 instance"
    type = string
}

variable "ami_id" {
    description = "AMI ID of the EC2 instance"
    type = string
}

variable "key_name" {
    description = "Name of the key pair"
    type = string
}
