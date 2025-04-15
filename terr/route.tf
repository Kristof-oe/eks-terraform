resource "aws_route_table" "route_priv" {

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.cidr_block_route
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "${local.env}-priv"
  }

}

resource "aws_route_table" "route_pub" {

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.cidr_block_route
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${local.env}-pub"
  }

}


resource "aws_route_table_association" "piv1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.route_priv.id
}

resource "aws_route_table_association" "piv2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.route_priv.id
}

resource "aws_route_table_association" "pub1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.route_pub.id
}

resource "aws_route_table_association" "pub2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.route_pub.id
}