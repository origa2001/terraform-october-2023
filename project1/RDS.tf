

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.main3.id,aws_subnet.main4.id]
}

resource "aws_db_instance" "my_db_instance" {
  identifier            = "mydbinstance"
  allocated_storage     = 20
  storage_type          = "gp2"
  engine                = "mysql"
  engine_version        = "5.7"
  instance_class        = "db.t2.micro"
  username              = "admin"
  password              = "kaizen123"
  publicly_accessible   = true
  db_subnet_group_name  = aws_db_subnet_group.db_subnet_group.name
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]


  tags = {
    Name = "MyDBInstance"
  }
}

output "rds_endpoint" {
  value = "${aws_db_instance.my_db_instance.endpoint}"
}

# resource "aws_security_group" "db_sg" {
#   name        = "db_sg"
#   description = "Security group for the database"

#   ingress {
#     from_port = 3306
#     to_port   = 3306
#     protocol  = "tcp"
#     security_group_ids = [aws_security_group.sg-group1.id]
#   }
# }





  


