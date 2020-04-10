resource "aws_subnet" "publicES" {
  vpc_id            = aws_vpc.vpchans.id
  cidr_block        = var.Subnet-Publics
  availability_zone = data.aws_availability_zones.available.names[0]
}
resource "aws_route_table_association" "publicES" {
  subnet_id      = aws_subnet.publicES.id
  route_table_id = aws_route_table.public.id
}