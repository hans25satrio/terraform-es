data "aws_availability_zones" "available" {}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpchans.id
}
resource "aws_network_acl" "all" {
  vpc_id = aws_vpc.vpchans.id
  egress {
    protocol   = "-1"
    rule_no    = 2
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = "-1"
    rule_no    = 1
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpchans.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpchans.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.publicnat.id
  }
}

resource "aws_eip" "Nat" {
  vpc = true
}

resource "aws_nat_gateway" "publicnat" {
  allocation_id = aws_eip.Nat.id
  subnet_id     = aws_subnet.publicES.id
  depends_on    = [aws_internet_gateway.gw]
}