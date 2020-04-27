# Security Group used by the ec2_instance
resource "aws_security_group" "main_sg" {
  name   = "main-sg"
  vpc_id = aws_vpc.main.id
}

# SSH rule used by the ec2_instance
resource "aws_security_group_rule" "allow_ssh" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.main_sg.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow SSH from everywhere"
}

# HTTP rule used by the ec2_instance
# Once the container is deployed, it will be accessible on this instance on port 80
resource "aws_security_group_rule" "allow_http" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.main_sg.id
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow HTTP from everywhere"
}

# This instance will have internet connection.
resource "aws_security_group_rule" "allow-outbound" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.main_sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow OUTPUT to everywhere"
}

# Security Group used by the database_instance
resource "aws_security_group" "db_sg" {
  name   = "db-sg"
  vpc_id = aws_vpc.main.id
}

# PostgreSQL rule used by the database_instance, which will allow the ec2_instance to connect to it on port 5432
resource "aws_security_group_rule" "allow_db_connection" {
  from_port                = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_sg.id
  to_port                  = 5432
  type                     = "ingress"
  source_security_group_id = aws_security_group.main_sg.id
  description              = "Allow db query from webserver"
}
