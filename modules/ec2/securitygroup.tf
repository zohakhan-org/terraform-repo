data "aws_ip_ranges" "us_east_ip_ranges" {
  regions = [var.aws_region]
  services =["ec2"]
}
resource "aws_security_group" "sg_custom_us_east" {
  name = "sg_custom_us_east"
  description = "Custom Security Group for EC2 instances in us-east"
  ingress {
    from_port = "443"
    to_port = "443"
    protocol = "tcp"
    cidr_blocks = slice(data.aws_ip_ranges.us_east_ip_ranges.cidr_blocks, 0, 60)

  }
  tags = {
    CreateDate= data.aws_ip_ranges.us_east_ip_ranges.create_date
    SyncToken= data.aws_ip_ranges.us_east_ip_ranges.sync_token
  }
}