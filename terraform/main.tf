provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "3-tier-task-vpc" }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "3-tier-task-gateway" }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = var.az_a
  map_public_ip_on_launch = true
  tags = { Name = "3-tier-task-public-subnet-a" }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = var.az_b
  map_public_ip_on_launch = true
  tags = { Name = "3-tier-task-public-subnet-b" }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = var.az_a
  tags = { Name = "3-tier-task-private-subnet-a" }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = var.az_b
  tags = { Name = "3-tier-task-private-subnet-b" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = { Name = "3-tier-task-public-rt" }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "flask_sg" {
  name        = "3-tier-task-sg"
  description = "Allow SSH, Flask, Grafana, Prometheus"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "3-tier-task-sg" }
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "3-tier-task-key"
  public_key = file(var.ec2_public_key_path)
}

resource "aws_instance" "flask_app" {
  ami                         = var.ec2_ami_id
  instance_type               = var.ec2_instance_type
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.flask_sg.id]
  key_name                    = aws_key_pair.ec2_key.key_name
  associate_public_ip_address = true
  user_data = file(var.user_data_file)

  tags = {
    Name = "3-tier-task-ec2"
  }
}
resource "aws_db_subnet_group" "task_db_group" {
  name       = "three-tier-task-db" 
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]

  tags = {
    Name = "3-tier-task-db-subnet-group"
  }
}


resource "aws_db_instance" "task_db" {
  identifier              = "three-tier-task-db"
  engine                  = "mysql"
  instance_class          = var.rds_instance_class
  allocated_storage       = 20
  db_subnet_group_name    = aws_db_subnet_group.task_db_group.name
  vpc_security_group_ids  = [aws_security_group.flask_sg.id]
  db_name                 = var.rds_db_name
  username                = var.rds_username
  password                = var.rds_password
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false
  backup_retention_period = 0
  tags = {
    Name = "3-tier-task-db"
  }
}
