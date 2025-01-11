# --------------------------------------------------------------------------------
#  VPC Subnet データソース
# --------------------------------------------------------------------------------

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc.id}"]
  }
}

data "aws_subnet" "subnet_1" {
  filter {
    name   = "tag:Name"
    values = ["${var.subnet_1.id}"]
  }
}

data "aws_subnet" "subnet_2" {
  filter {
    name   = "tag:Name"
    values = ["${var.subnet_2.id}"]
  }
}
