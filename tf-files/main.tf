terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.41"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "web" {
  count             = var.counter
  ami               = data.aws_ami.ubuntu.id # latest ubuntu 22.04 64-bit AMI
  instance_type     = var.instance_type
  key_name          = var.key_pair_name
  availability_zone = "${var.region}${var.availability_zone}"
  security_groups   = [aws_security_group.terraform_allow.name]
  user_data         = file("${var.action_file}")

  tags = {
    Version = "${var.instance_tag}"
  }
    # Lifecycle for better uptime
  lifecycle {
    create_before_destroy = true

    # Force recreation if Docker image tag changes
    ignore_changes = [
      user_data,           # Ignore changes to user_data
      ami,                 # Ignore changes to AMI ID
      instance_type,       # Ignore changes to instance type
      security_groups,     # Ignore changes to security groups
    ]
  }
}