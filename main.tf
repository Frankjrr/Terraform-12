provider "aws" {
  // configuration files here
}

// create a new vpc
resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "dev-vpc"
  }
}

// create a new subnet for the above vpc
resource "aws_subnet" "dev-subnet" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = "10.0.0.0/20"

  tags = {
    Name = "dev-subnet"
  }
}

// query the existing default vpc id from data block
data "aws_vpc" "existing" {
  default = true
}

// creating a new subnet in the existing vpc
resource "aws_subnet" "dev-subnet-2" {
  vpc_id     = data.aws_vpc.existing.id
  cidr_block = "172.31.48.0/20"

  tags = {
    Name = "dev-subnet-2"
  }
}

