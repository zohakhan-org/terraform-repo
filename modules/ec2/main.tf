data "aws_availability_zones" "available" {}
data "aws_ami" "latest-ubuntu" {
    most_recent = true
    owners = ["099720109477"]
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_instance" "ec2_instance" {
  ami = data.aws_ami.latest-ubuntu.id
  instance_type = var.ec2_instance_type
  count = var.ec2_instance_count
  availability_zone = data.aws_availability_zones.available.names[1]
  provisioner "local-exec" {
    command = "echo ${aws_instance.ec2_instance.private_ip} >> private_ips.txt"
  }

  tags = {
    Name = (var.ec2_instance_name)
  }
}
