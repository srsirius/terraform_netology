variable "AWS_ACCESS_KEY_ID" {
  type = string
  }

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
  }

provider "aws" {
  region = "us-east-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  }

resource "aws_s3_bucket" "bucket1" {
  bucket  = "sirius-bucket"
  acl     = "private"
  }

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "app-state"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"] 

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

locals {
  web_instance_type_map = {
    stage = "t3.micro"
    prod  = "t3.large"
  }
}

locals {
  web_instance_count_map = {
    stage = 1
    prod  = 2
  }

}

resource "aws_instance" "web" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = local.web_instance_type_map[terraform.workspace]
  count = local.web_instance_count_map[terraform.workspace]
}

locals {
  instances_stage = {
    "t3.micro" = data.aws_ami.amazon_linux.id
  }
  instances_prod = {
    "t3.large" = data.aws_ami.amazon_linux.id
    "t3.large" = data.aws_ami.amazon_linux.id
  }
}

resource "aws_instance" "web2" {

  for_each = terraform.workspace == "prod" ? local.instances_prod : local.instances_stage

  ami = each.key
  instance_type = each.value

  lifecycle {
    create_before_destroy = true
    ignore_changes = [ tags ]
  }
}

