resource "aws_db_instance" "rds" {
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  identifier             = "mydb"
  username               = "root"
  password               = "Pass1234"
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.mydbsubgp.name
  skip_final_snapshot    = true
}

resource "aws_db_subnet_group" "mydbsubgp" {
  name       = "mydbsubsp"
  subnet_ids = [var.dbsubnet_id,var.appsubnet_id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_security_group" "db-sg" {
vpc_id = var.vpc_id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.32.0/24"]
  }
   egress {
   from_port = 0
   to_port = 0
   protocol = -1
   cidr_blocks = ["0.0.0.0/0"]
}
}