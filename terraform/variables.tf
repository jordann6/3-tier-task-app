variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_a_cidr" {
  description = "CIDR for public subnet A"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
  description = "CIDR for public subnet B"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_a_cidr" {
  description = "CIDR for private subnet A"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_b_cidr" {
  description = "CIDR for private subnet B"
  type        = string
  default     = "10.0.4.0/24"
}

variable "az_a" {
  description = "Availability zone A"
  type        = string
  default     = "us-east-1a"
}

variable "az_b" {
  description = "Availability zone B"
  type        = string
  default     = "us-east-1b"
}

variable "ec2_ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c2b8ca1dad447f8a" 
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ec2_public_key_path" {
  description = "Path to public key file for EC2"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
variable "rds_instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_db_name" {
  description = "Initial database name"
  type        = string
  default     = "taskdb"
}

variable "rds_username" {
  description = "Master DB username"
  type        = string
  default     = "Jordann6"
}

variable "rds_password" {
  description = "Master DB password"
  type        = string
  default     = "SampleOne"
  sensitive   = true
}
variable "user_data_file" {
  description = "Path to the EC2 user_data.sh script"
  type        = string
  default     = "../user_data.sh"
}
