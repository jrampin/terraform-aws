resource "aws_db_instance" "db" {
  identifier                = "techtestapp-db-postgres"
  allocated_storage         = 5
  storage_type              = "gp2"
  engine                    = "postgres"
  engine_version            = "9.6"
  instance_class            = "db.t3.small"
  name                      = "app"
  username                  = "postgres"
  password                  = "7gVLcH3LfqhFTHup"
  port                      = "5432"
  storage_encrypted         = false
  maintenance_window        = "Mon:00:00-Mon:03:00"
  backup_window             = "03:00-06:00"
  backup_retention_period   = 0
  vpc_security_group_ids    = [aws_security_group.db_sg.id]
  db_subnet_group_name      = aws_db_subnet_group.db_subnet.id
  final_snapshot_identifier = "techtestapp-db-postgres"
  deletion_protection       = false
  skip_final_snapshot       = true


  # This provisioner will get the database endpoint and save its output into the endpoint.yml, which will be used as a variable file by Ansible
  provisioner "local-exec" {
    command = "echo db_endpoint: ${aws_db_instance.db.endpoint} > endpoint.yml; sed -ie '1s/:5432//' endpoint.yml"
  }

  tags = {
    Name = "TechTestApp PostgreSQL database"
  }
}

