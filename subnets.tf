# Public subnet is used by the webserver and it is accessible from the internet
# main-sg allows only SSH and HTTP from the internet (ingress)

resource "aws_subnet" "public_subnet" {
  cidr_block              = var.public_subnet
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "public-subnet"
  }
}

# Subnet group that provides HA for the database instance.
# It has two private subnets (in different AZ) and it is only accessible internaly

resource "aws_db_subnet_group" "db_subnet" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
}

resource "aws_subnet" "private_subnet1" {
  cidr_block        = var.private_subnet1
  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "private-subnet1"
  }
}

resource "aws_subnet" "private_subnet2" {
  cidr_block        = var.private_subnet2
  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "private-subnet2"
  }
}
