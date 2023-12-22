provider "aws" {
    region = "us-east-2"
}

data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t2.micro"
  availability_zone = "us-east-2a"
    vpc_security_group_ids = [aws_security_group.homework-sg.id]
    key_name = aws_key_pair.deployer.key_name
    user_data = file("httpd.sh")
    count = 1

  tags = {
    Name = "homework-ec2"
  }
}

resource "aws_security_group" "homework-sg" {
  name        = "homework-sg"
  description = "For HW part1"
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "RDS"
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

resource "aws_key_pair" "deployer" {
  key_name   = "homework-key"
  public_key = file("~/.ssh/id_rsa.pub")
  
  tags = {
    Name = "homework-key"
  }
}

resource "aws_key_pair" "laptop" {
  key_name   = "my-laptop-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCb5sjutNsDWY98n5hcFD1e8NW5zvwauiTwcUwqcT7ojk/2eLIaOO8kjuw3ymK5quPzIA0PMwH5TVdPOyNTtcwEjnOylRm+nbMlmwj9Lr6Fb8DlvpypzhuYTG8NZfjosakC13tnPbaasueain4y3XUolF2txYaN7NpdsXAPM4wWbJ2CKIwOAXm9bjIJf2wd+z06V/KV/dlV4h2l1hPMdmHP86AJu7ZSyG4tZA4k1EtC+gNPDyJhUZ+hP1h+jg7tzZYag1vHpnUyS8Mz8eLfeFjrwAowt8+tBlWWRYH+3CKBYAk1O3TimnLqPTJUdC6OXhg5Xe2UtnrSEAzzOD8FnM5oDGLibeMIW+AixbXzKo+aF9yoNnMVD4zQkgFBAjL2hXm/LbDhPykiDPo36XD6NxXeDYEtsNJZnM3ry4hXAMCZBFEuKIeYjAQW5YVNZAKdSZykba0NCcSwSxzQR73Obr6jC+1FRBD7HG649S5hrAGpTV3RtarM1kaqTijPetnRohU= origa@Olgas-MBP.attlocal.net"
}


# output aws_security_group {
#    value = aws_security_group.homework-sg.id
# }


