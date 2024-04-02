provider "aws" {
  // configuration files here
}

variable "subnet-cidr-block" {
  // add description
  description = "subnet cidr block"
  //add default file value in case it didnt file with name = terraform.tfvars
  //default = "10.0.0.0/20"
  // =====================
  // define type of the variable as a constraints
  // type = list(string) // lsit of strings
}

// create a new vpc
resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "development"
  }
}

// create a new subnet for the above vpc
resource "aws_subnet" "dev-subnet" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = var.subnet-cidr-block

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



