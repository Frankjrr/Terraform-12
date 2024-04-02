provider "aws" {}

// variable block
variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "env_prefix" {}
variable "avail_zone" {}
// -------------variable block-------------------------

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block

   tags = {
    Name = "${var.env_prefix}-vpc"
  }
}
resource "aws_subnet" "myapp-subnet1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name = "${var.env_prefix}-subnet"
  }

}

#resource "aws_route_table" "myapp-routetable" {
#  vpc_id = aws_vpc.myapp-vpc.id
#
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_internet_gateway.myapp-igw.id
#  }
#
#  tags = {
#     Name = "${var.env_prefix}-rtb"
#  }
#}

resource "aws_default_route_table" "default-rtb" {
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }

  tags = {
    Name = "${var.env_prefix}-main-rtb"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id

  tags = {
    Name = "${var.env_prefix}-igw"
  }
}


// create a new sg group for our vpc instead of the default one
#resource "aws_security_group" "myapp-sg" {
#  name        = "myapp-sg"
#  vpc_id      = aws_vpc.myapp-vpc.id
#
# ingress {
#    from_port = 22
#    to_port = 22
#    protocol = "TCP"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  ingress {
#    from_port = 8080
#    to_port = 8080
#    protocol = "TCP"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  egress {
#    from_port = 0
#    to_port = 0
#    protocol = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#    prefix_list_ids = []
#  }
#
#  tags = {
#    Name: "${var.env_prefix}-myapp-sg-sg"
#  }
#}


// using default sg for the created vpc
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.myapp-vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name: "${var.env_prefix}-default-sg"
  }

}

#resource "aws_route_table_association" "a-rtb-subnet" {
#  subnet_id = aws_subnet.myapp-subnet1.id
#  route_table_id = aws_route_table.myapp-routetable.id
#}