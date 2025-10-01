provider "aws" {
  region  = "us-east-1"
  # profile = "tkxel"
}

# ---------------- VPC ----------------
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "VPC-one"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet"
  }
}
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "IGW"
  }
}
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "public_sg" {
  name_prefix = "public-sg-"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "public_sg"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "AmiLinux" {
  type = map(string)
  default = {
    
    us-east-1  = "ami-06a91e99895983c2a"
  }
}

variable "region" {
  default = "us-east-1"
}

# ---------------- SSH Key ----------------
# Generate SSH private key
resource "tls_private_key" "auth_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Register the public key with AWS
resource "aws_key_pair" "auth_key" {
  key_name   = "auth"
  public_key = tls_private_key.auth_key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.auth_key.private_key_pem
  filename        = pathexpand("~/.ssh/auth.pem")
  file_permission = "0600"
}

# ---------------- EC2 Instances ----------------

resource "aws_instance" "host" {
  ami                         = lookup(var.AmiLinux, var.region)
  instance_type               = "t3.nano"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.auth_key.key_name
  

  root_block_device {
    volume_type = "gp3"
    volume_size = 8
  }

  tags = {
    Name = "Host"
  }
}

