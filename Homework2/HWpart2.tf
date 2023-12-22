resource "aws_instance" "part2" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.laptop.key_name
  
  #terraform import aws_instance.part2 i-0314f2779a079b18e
}

resource "aws_security_group" "part2sg" {
  name        = "my-test"
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
# #terraform import aws_security_group.part2sg sg-02e9df2d858bd8e19

# terraform destroy 
#Resources: 5 destroyed.

