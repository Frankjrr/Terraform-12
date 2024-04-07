resource "aws_default_security_group" "default" {
  vpc_id = var.vpc_id

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

resource "aws_key_pair" "ssh-key" {
  key_name = "my-key"
  public_key = file(var.public_key_location)
}


// getting latest aws instance id bases on filters
data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

// creating the ec2
resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type
  subnet_id = var.subnetid
  availability_zone = var.avail_zone
  vpc_security_group_ids = [aws_default_security_group.default.id]
  associate_public_ip_address = true
  key_name = aws_key_pair.ssh-key.key_name
  #user_data = file("entry-script.sh")
  user_data_replace_on_change = true


  tags = {
    Name: "${var.env_prefix}-server"
  }
}
