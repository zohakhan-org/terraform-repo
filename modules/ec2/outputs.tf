  output "public_ip" {
    value = [for instance in aws_instance.ec2_instance : instance.public_ip]
  }