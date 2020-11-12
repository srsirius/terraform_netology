variable "AWS_ACCESS_KEY_ID" {
  type = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
}

provider "aws" {
  region = "us-west-2"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY


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

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  cpu_core_count = "2"
  cpu_threads_per_core = "2"
  private_ip = "10.10.10.2"

  tags = {
    Name = "HelloWorld"
  }
}

variable "user_id" {
  type = string
  default = "siriusiam"
}

data "aws_caller_identity" "current" {}

data "aws_region" "us-east-1" {}


