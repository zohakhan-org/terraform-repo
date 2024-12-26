output "public_ip" {
  value = aws_instance.ec2_instance[count.index].public_ip
}