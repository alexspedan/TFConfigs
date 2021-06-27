provider "aws" {
	region = "eu-north-1"
}

resource "aws_instance" "web" {
	ami = "ami-00514a528eadbc95b" // Amazon Linux
	instance_type = "t3.micro"
	tags = {
		Name = "HelloWorld"
	}
}
#до этого должно быть норм
#Ищем название ami автоматически
#data "aws_ami" "amazon_linux" {
#	most_recent = true
#	owners      = ["amazon"]
#	filter {
#		name = "name"
#		values = ["amzn-ami-hvm-*-x86_64-gp2"]
#	}filter {
#		name = "owner-alias"
#		values = ["amazon"] 
#	}
#}
#resource "aws_instance" "web" {
#	ami = data.aws_ami.amazon_linux.id
#instance_type = "t3.micro"
#}

#Добавляем зависимость от вокплейса

locals {
	web_instance_type_map = {
		stage = "t2.micro"
		prod = "t2.large"
	}
}
resource "aws_instance" "web" {
	ami = data.aws_ami.amazon_linux.id
	instance_type = local.web_instance_type_map[terraform.workspace]
}

#Создаем несколько ресурсов

locals {
	web_instance_count_map = {
		stage = 1
		prod = 2
}
resource "aws_instance" "web" {
	ami = data.aws_ami.amazon_linux.id
	instance_type = "t2.micro"
	count = local.web_instance_count_map[terraform.workspace]
}


#Еще один цикл
locals {
	instances = {
	"t2.micro" = data.aws_ami.amazon_linux.id
	"t2.large" = data.aws_ami.amazon_linux.id
	}
}
resource "aws_instance" "web" {
	for_each = local.instances
	ami = each.value
	instance_type = each.key
}