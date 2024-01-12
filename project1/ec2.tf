
data "aws_ami" "amazon-linux-2" {
 most_recent = true


 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }


 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}


resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = var.instance_type
  availability_zone = var.availability_zone_name1
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
  



resource "aws_key_pair" "deployer" {
  key_name   = "my-mac-key"
  public_key = file("~/.ssh/id_rsa.pub")
 
}

output instance {
    value = aws_instance.example.public_ip
}