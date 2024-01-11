resource "aws_instance" "example" {
  ami           = "ami-011ab7c70f5b5170a"
  instance_type = "t2.micro"
  availability_zone = "us-east-2a"
    vpc_security_group_ids = [aws_security_group.sg-group1.id]
    key_name = aws_key_pair.deployer.key_name
    # user_data = file("project1.sh")
    subnet_id = aws_subnet.main1.id
  tags = {
    Name = "group-2"
  }
}
resource "null_resource" "cluster" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    always_run = "${timestamp()}"
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = element(aws_instance.example[*].public_ip, 0)
    type = "ssh"
    user = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
        "sudo yum update -y",
        "sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2", 
        "sudo yum install mariadb-server -y",
        "sudo yum install httpd -y",
        "sudo systemctl start httpd",
        "sudo systemctl enable httpd",
        "wget https://wordpress.org/latest.tar.gz",
        "tar xvf latest.tar.gz",
        "sudo chown -R apache:apache /var/www/html/",
        "sudo cp -R wordpress/*  /var/www/html/"
]
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