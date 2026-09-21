# Variables for VPC Components
variable "ami" {
  description = "AMI for the EC2 Instance"
}

variable "instance_type" {
  description = "Instance Type For EC2 Instance"
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID For EC2 Instance"
}

variable "key_name" {
  description = "Key Pair For EC2 Instance"
}

variable "vpc_security_group_ids" {
  description = "Security Group For EC2 Instance"
}

variable "user_data" {
  description = "User Data For EC2 Instance"
}

variable "instance_name" {
  description = "Name For EC2 Instance"
}
