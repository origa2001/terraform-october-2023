resource "aws_instance" "part2" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.laptop.key_name
  #terraform import aws_key_pair.laptop my-laptop-key
  #terraform import aws_instance.part2 i-004ba8fc659d21f41
}

resource "aws_security_group" "part2" {
  name        = "part2-SG"
  description = "for HW2"
  ingress {
    
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
#terraform import aws_security_group.part2 sg-03f38431b6ca773df



