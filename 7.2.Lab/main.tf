terraform {
}



provider "aws" {
  region = "eu-north-1"
}
data "aws_ami" "ubuntu" {
        most_recent = true

        filter {
                name = "name"
                values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]

        }
        filter {
                name = "virtualization-type"
                values = ["hvm"]
        }
                owners = ["099720109477"] # Canonical

}



resource "aws_instance" "EC2-test" {
        ami = data.aws_ami.ubuntu.id
        instance_type = "t3.micro"
        tags = { Name = "Terraform Netology"
        }
}
resource "aws_vpc" "my_vpc" {
        cidr_block = "172.16.0.0/16"
        tags = {
        Name = "tf-example"
  }
}

resource "aws_subnet" "my_subnet" {
        vpc_id = aws_vpc.my_vpc.id
        cidr_block = "172.16.10.0/24"
        availability_zone = "us-west-2a"
        tags = {
        Name = "tf-example"
  }
