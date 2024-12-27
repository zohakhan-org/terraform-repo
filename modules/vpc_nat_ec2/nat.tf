#Define External IP
resource "aws_eip" "packet-nat" {
  vpc      = true

}

resource "aws_nat_gateway" "pocket-nat-gw" {
  allocation_id = aws_eip.packet-nat.id
  subnet_id     = aws_subnet.pocket_vpc_public_1.id
  depends_on = [aws_internet_gateway.pocket-gw]
}

resource "aws_route_table" "pocket-private-rt" {
  vpc_id = aws_vpc.pocket_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.pocket-nat-gw.id
    }
  tags = {
    Name = "pocket-private-rt"
  }
}
resource "aws_route_table_association" "pocket-private-rt-assoc-1-a" {
    subnet_id      = aws_subnet.pocket_vpc_private_1.id
  route_table_id = aws_route_table.pocket-private-rt.id
}

resource "aws_route_table_association" "pocket-private-rt-assoc-1-b" {
    subnet_id      = aws_subnet.pocket_vpc_private_2.id
  route_table_id = aws_route_table.pocket-private-rt.id
}

resource "aws_route_table_association" "pocket-private-rt-assoc-1-c" {
    subnet_id      = aws_subnet.pocket_vpc_private_3.id
  route_table_id = aws_route_table.pocket-private-rt.id
}