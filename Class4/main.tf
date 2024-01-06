provider "aws" {
  region = var.region
}

resource "aws_key_pair" "deployer" {
  key_name   = "my-key"
  public_key = file("~/.ssh/id_rsa.pub")
}


variable region {
    type = string
    default = ""
}