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

output "dev-vpc-id" {
  value = aws_vpc.dev-vpc.id
}
output "dev-subnet-id" {
  value = aws_subnet.dev-subnet.id
}



