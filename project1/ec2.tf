resource "aws_instance" "example" {
  ami           = "ami-011ab7c70f5b5170a"
  instance_type = "t2.micro"
  availability_zone = "us-east-2a"
    vpc_security_group_ids = [aws_security_group.sg-group1.id]
    key_name = aws_key_pair.deployer.key_name
    user_data = file("project1.sh")
    subnet_id = aws_subnet.main1.id


  tags = {
    Name = "group-2"
  }
}
# data "aws_ami" "amzn-linux-2023-ami" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["al2023-ami-2023.*-x86_64"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }

resource "aws_key_pair" "deployer" {
  key_name   = "my-mac-key"
  public_key = file("~/.ssh/id_rsa.pub")
 
}

output instance {
    value = aws_instance.example.public_ip
}