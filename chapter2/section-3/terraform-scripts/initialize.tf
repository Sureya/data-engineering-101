
terraform {
  required_version = "~> 0.12"
}

provider "aws" {
  region = var.region
  profile = var.aws_creds_profile
}

# Fetch the default VPC details
data "aws_vpc" "default" {
  default = true
}

# Fetch subnets for Default VPC
data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

# Fetch the SGs associated with VPC
data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  name   = "default"
}

data "external" "script" {
  depends_on = [data.aws_security_group.default]
  working_dir = "${path.module}/"
  program = ["bash", "get_public_address.sh"]
  query = {}
}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}