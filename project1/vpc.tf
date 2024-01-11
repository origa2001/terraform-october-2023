provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "main" {               #VPC
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "group-1"
  }
}
resource "aws_subnet" "main1" {            #public_subnet1
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-1"
  }
}
resource "aws_subnet" "main2" {               #public_subnet2
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2b"
map_public_ip_on_launch = true
  tags = {
    Name = "Public-2"
  }
}
resource "aws_subnet" "main3" {               #private_subnet1
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-2c"
map_public_ip_on_launch = false
  tags = {
    Name = "Private1"
  }
}
resource "aws_subnet" "main4" {                #private_subnet2
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-2b"
map_public_ip_on_launch = false
  tags = {
    Name = "Private2"
  }
}

resource "aws_internet_gateway" "gw" {             #internet_gateway
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-IGW"
  }
}

resource "aws_route_table" "example" {              #route_table_IGW
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "my-RT"
  }
}

resource "aws_route_table" "nat" {         #route_table NAT
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_nat_gateway.id
  }
  tags = {
    Name = "my-NATRT"
  }
}




resource "aws_nat_gateway" "my_nat_gateway" {           #NAT_gateway
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.main1.id
}

resource "aws_eip" "nat_eip" {                          #elastic_IP
  domain = "vpc" 
}




resource "aws_route_table_association" "a" {             #association_RT
  subnet_id      = aws_subnet.main1.id
  route_table_id = aws_route_table.example.id
}
resource "aws_route_table_association" "a1" {
  subnet_id      = aws_subnet.main2.id
  route_table_id = aws_route_table.example.id
}
resource "aws_route_table_association" "a2" {
  subnet_id      = aws_subnet.main3.id
  route_table_id = aws_route_table.example.id
}

resource "aws_route_table_association" "a3" {            #association_RT_NAT
  subnet_id      = aws_subnet.main4.id
  route_table_id = aws_route_table.nat.id
}



resource "aws_security_group" "sg-group1" {          #security_groups for instance
  name        = "group-1"
  description = "Allow TLS inbound traffic"
  vpc_id = aws_vpc.main.id
  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "TLS from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "rds_sg" {        #security_groups for RDS
  name        = "rds_sg"
  description = "Security group for RDS"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.main4.cidr_block]
  }
}

# #elastic ip
# resource "aws_eip" "eip" {
#   domain = "vpc"
# }

# #nat gateway
# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.eip.id
#   subnet_id     = aws_subnet.main1.id

#   tags = {
#     Name = "project-nat"
#   }
# }

# resource "aws_eip_association" "example_instance_eip_association" {
#   instance_id          = aws_instance.example.id
#   allocation_id        = aws_eip.eip.id
# }







# resource "aws_route_table" "public_route_table" {
#   vpc_id = aws_vpc.my_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.my_nat_gateway.id
#   }
# }

# resource "aws_route_table_association" "public_subnet_association" {
#   subnet_id      = aws_subnet.public_subnet.id
#   route_table_id = aws_route_table.public_route_table.id
# }

# # Create NAT Gateway
# resource "aws_nat_gateway" "my_nat_gateway" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.public_subnet.id
# }

# resource "aws_eip" "nat_eip" {
#   vpc = true
# }

# Create private subnet with RDS instance
# resource "aws_subnet" "private_subnet" {
#   vpc_id                  = aws_vpc.my_vpc.id
#   cidr_block              = "10.0.2.0/24"
#   availability_zone       = "your_different_availability_zone"
# }

# Create security group for RDS
# resource "aws_security_group" "rds_sg" {
#   name        = "rds_sg"
#   description = "Security group for RDS"

#   ingress {
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     cidr_blocks = [aws_subnet.private_subnet.cidr_block]
#   }
# }

# Create RDS instance in private subnet
# resource "aws_db_instance" "db_instance" {
#   identifier            = "mydbinstance"
#   allocated_storage     = 20
#   storage_type          = "gp2"
#   engine                = "mysql"
#   engine_version        = "5.7"
#   instance_class        = "db.t2.micro"
#   username              = "dbuser"
#   password              = "dbpassword"
#   publicly_accessible   = false
#   db_subnet_group_name  = aws_db_subnet_group.db_subnet_group.name
#   vpc_security_group_ids = [aws_security_group.rds_sg.id]

#   tags = {
#     Name = "MyDBInstance"
#   }
# }

# # Create a DB subnet group for the private subnet
# resource "aws_db_subnet_group" "db_subnet_group" {
#   name       = "my-db-subnet-group"
#   subnet_ids = [aws_subnet.private_subnet.id]
# }


