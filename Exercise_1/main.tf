# DONE Designate a cloud provider, region, and credentials
provider "aws" {
  region  = "us-east-1"
  profile = "miro-udacity"
}

# DONE: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "Udacity_T2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  count         = 4
  tags = {
    Name = "Udacity T2"
  }
}

# DONE: provision 2 m4.large EC2 instances named Udacity M4
# resource "aws_instance" "Udacity_M4" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "m4.large"
#   count         = 2
#   tags = {
#     Name = "Udacity M4"
#   }
# }


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