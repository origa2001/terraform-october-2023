provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "kaizen"
  }
}
resource "aws_subnet" "main1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Main1"
  }
}
resource "aws_subnet" "main2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2b"
map_public_ip_on_launch = true
  tags = {
    Name = "Main2"
  }
}
resource "aws_subnet" "main3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-2c"
map_public_ip_on_launch = true
  tags = {
    Name = "Main3"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-IGW"
  }
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "my-RT"
  }
}
resource "aws_route_table_association" "a" {
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

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
    subnet_id = aws_subnet.main1.id

    vpc_security_group_ids = [aws_security_group.allow_tls.id]
    key_name = aws_key_pair.deployer.key_name
    user_data = file("apache.sh")
}
output ec2 {
  value = aws_instance.web.public_ip
}

resource "aws_key_pair" "deployer" {
  key_name   = "hello"
  public_key = file("~/.ssh/id_rsa.pub")
}
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
