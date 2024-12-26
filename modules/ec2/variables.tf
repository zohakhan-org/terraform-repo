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

variable "AMIS" {
  type = map
  default= {
    us-east-1 = "ami-0b0ea68c435eb488d"
    us-east-2 = "ami-05803413c51f242b7"
    us-west-1 = "ami-0454207e5367abf01"
    us-west-2 = "ami-0688ba7eeeeefe3cd"
  }
}