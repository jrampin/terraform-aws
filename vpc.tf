data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "terraform-main-vpc"
  }
}

# As we are creating a new VPC, by default it doesn't have internet connectivity.
# That is why I'm creating an internet gateway, public route and associating it to the public_subnet
# Otherwise the webserver wouldn't be accessible from the internet

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.public_route_table
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_default_route_table" "private_route" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_assoc" {
  route_table_id = aws_route_table.public_route.id
  subnet_id      = aws_subnet.public_subnet.id
  depends_on = [
    aws_route_table.public_route,
    aws_subnet.public_subnet,
  ]
}

resource "aws_route_table_association" "private_subnet1_assoc" {
  route_table_id = aws_default_route_table.private_route.id
  subnet_id      = aws_subnet.private_subnet1.id
  depends_on = [
    aws_default_route_table.private_route,
    aws_subnet.private_subnet1,
  ]
}

resource "aws_route_table_association" "private_subnet2_assoc" {
  route_table_id = aws_default_route_table.private_route.id
  subnet_id      = aws_subnet.private_subnet2.id
  depends_on = [
    aws_default_route_table.private_route,
    aws_subnet.private_subnet2,
  ]
}
