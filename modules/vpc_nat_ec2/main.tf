resource "aws_vpc" "pocket_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true
  enable_classiclink = false

    tags = {
    Name = "pocket_vpc"
    }
}

resource "aws_subnet" "pocket_vpc_public_1" {
  vpc_id = aws_vpc.pocket_vpc.id
    cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
    tags = {
    Name = "pocket_vpc_public_1"
    }
}

resource "aws_subnet" "pocket_vpc_public_2" {
  vpc_id = aws_vpc.pocket_vpc.id
    cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-2a"
    tags = {
    Name = "pocket_vpc_public_2"
    }
}

resource "aws_subnet" "pocket_vpc_public_3" {
  vpc_id = aws_vpc.pocket_vpc.id
    cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-3a"
    tags = {
    Name = "pocket_vpc_public_3"
    }
}

resource "aws_subnet" "pocket_vpc_private_1" {
  vpc_id = aws_vpc.pocket_vpc.id
  cidr_block = "10.0.4.0/24"
  map_public_ip_on_launch = false
  availability_zone = "us-east-1b"
    tags = {
    Name = "pocket_vpc_private_1"
    }
}

resource "aws_subnet" "pocket_vpc_private_2" {
  vpc_id = aws_vpc.pocket_vpc.id
    cidr_block = "10.0.5.0/24"
  map_public_ip_on_launch = false
  availability_zone = "us-east-2b"
    tags = {
    Name = "pocket_vpc_private_2"
    }
}

resource "aws_subnet" "pocket_vpc_private_3" {
  vpc_id = aws_vpc.pocket_vpc.id
    cidr_block = "10.0.6.0/24"
  map_public_ip_on_launch = false
  availability_zone = "us-east-3b"
    tags = {
    Name = "pocket_vpc_private_3"
    }
}

#custom internet gateway
resource "aws_internet_gateway" "pocket-gw" {
  vpc_id = aws_vpc.pocket_vpc.id
    tags = {
    Name = "pocket-gw"
    }
}

#custom route table
resource "aws_route_table" "pocket-public-rt" {
  vpc_id = aws_vpc.pocket_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pocket-gw.id
  }
  tags = {
    Name = "pocket-public-rt"
  }
}
resource "aws_route_table_association" "pocket-public-rt-assoc-1" {
  subnet_id = aws_subnet.pocket_vpc_public_1.id
  route_table_id = aws_route_table.pocket-public-rt.id
}

resource "aws_route_table_association" "pocket-public-rt-assoc-2" {
  subnet_id = aws_subnet.pocket_vpc_public_2.id
  route_table_id = aws_route_table.pocket-public-rt.id
}
resource "aws_route_table_association" "pocket-public-rt-assoc-3" {
  subnet_id = aws_subnet.pocket_vpc_public_3.id
  route_table_id = aws_route_table.pocket-public-rt.id
}