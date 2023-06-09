resource "aws_security_group" "database_sg" {
  name        = "RDS"
  description = "Allow MySQL inbound traffic"
  vpc_id      = aws_vpc.myvpc.id
  ingress {
    description     = "inbound traffic"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.websg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #depends_on = [aws_security_group.websg]
}

### dabatase instance

resource "aws_db_instance" "db" {
  identifier = "databasee"
  engine     = "mysql"
  engine_version  = "8.0.28"
  instance_class  = "db.t2.micro"
  db_subnet_group_name  = aws_db_subnet_group.rds_subnet.name
  db_name   = var.database_name
  username  = var.database_user
  password    = var.database_password
  allocated_storage  = 20
  vpc_security_group_ids   = [aws_security_group.websg.id]
  skip_final_snapshot  = true
  depends_on    = [aws_db_subnet_group.rds_subnet]
}

###database subnet
resource "aws_db_subnet_group" "rds_subnet" {
  name       = "main"
  #subnet_ids = [aws_subnet.db_subnet.*.id]
  subnet_ids            = [for subnet in aws_subnet.db_subnet : subnet.id]
}