provider "aws" {
  region  = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.23.0"
    }
  }
  backend "s3" {
    bucket = "tf-remote-s3-bucket-betul"
    key = "env/dev/tf-remote-backend.tfstate"
    region = "us-east-1"
    dynamodb_table = "tf-s3-app-lock"
    encrypt = true
  }
}
locals {
  mytag = "oray-local-name"
}

data "aws_ami" "tf_ami" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20220606.1-x86_64-gp2"]
  }
}

resource "aws_instance" "tf-ec2" {
  ami           = data.aws_ami.tf_ami.id
  instance_type = var.ec2_type
  key_name      = "virginia-key"
  tags = {
    Name = "${local.mytag}-this is from my-ami"
  }
}

resource "aws_s3_bucket" "tf-s3" {
  # bucket = "var.s3_bucket_name.${count.index}"
  # count = var.num_of_buckets
  # count = var.num_of_buckets != 0 ? var.num_of_buckets : 1
  for_each = toset(var.users)
  bucket   = "oray-tf-s3-bucket-${each.value}"
}

resource "aws_iam_user" "new_users" {
  for_each = toset(var.users)
  name = each.value
}

output "uppercase_users" {
  value = [for user in var.users : upper(user) if length(user) > 6]
}


output "tf_example_public_ip" {
  value = aws_instance.tf-ec2.public_ip
}

# output "tf_example_s3_meta" {
#   value = aws_s3_bucket.tf-s3.region
# }

output "tf_example_private_ip" {
  value = aws_instance.tf-ec2.private_ip
}

output "s3-arn-1" {
  value = aws_s3_bucket.tf-s3["fredo"].arn
  }

 output "s3-arn-2" {
      value = aws_s3_bucket.tf-s3["santino"].arn
  }  