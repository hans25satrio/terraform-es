resource "aws_security_group" "hansessg" {
  name = "hansessg"
  tags = {
    Name = "hansessg"
  }
  vpc_id = aws_vpc.vpchans.id
  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "TCP"
    cidr_blocks = ["172.28.0.5/32"]
  }
  ingress {
    from_port   = 9300
    to_port     = 9300
    protocol    = "TCP"
    cidr_blocks = ["172.28.0.5/32"]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}