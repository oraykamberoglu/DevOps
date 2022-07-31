provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.22.0"
    }
  }
}

locals {
  mytag = "oray-local-name"
}

resource "aws_instance" "tf-ec2" {
  ami           = var.ec2_ami  # ami-0742b4e673072066f
  instance_type = var.ec2_type # t2.micro
  key_name      = var.key_name # your key name without .pem extension

  tags = {
    Name = "${var.ec2_name}-${local.mytag}-instance"
  }
}

resource "aws_s3_bucket" "tf-s3" {
  bucket = var.s3_bucket_name

  tags = {
    Name = "${local.mytag}-come from locals"
  }
}
