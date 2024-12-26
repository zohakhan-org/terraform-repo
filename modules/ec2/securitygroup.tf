data "aws_ip_ranges" "us_east_ip_ranges" {
  regions = var.aws_region
  services =["ec2"]
}
resource "aws_security_group" "sg-custom_us_east" {
  name = "sg-custom-us-east"
  ingress {
    from_port = "443"
    to_port = "443"
    protocol = "tcp"
    cidr_blocks = [data.aws_ip_ranges.us_east_ip_ranges.cidr_blocks]

  }
  tags = {
    CreateDate= data.aws_ip_ranges.us_east_ip_ranges.create_date
    SyncToken= data.aws_ip_ranges.us_east_ip_ranges.sync_token
  }
}