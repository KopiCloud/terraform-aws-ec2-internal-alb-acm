###############################
## Network Module - Variables #
###############################

# AWS AZ #1
variable "aws_az_1" {
  type        = string
  description = "AWS AZ"
  default     = "eu-west-1a"
}

# AWS AZ #2
variable "aws_az_2" {
  type        = string
  description = "AWS AZ"
  default     = "eu-west-1b"
}

# AWS AZ #3
variable "aws_az_3" {
  type        = string
  description = "AWS AZ"
  default     = "eu-west-1c"
}

# VPC
variable "vpc_cidr" {
  type        = string
  description = "CIDR for the VPC"
  default     = "10.11.0.0/16"
}

# Private Subnet #1
variable "private_subnet_cidr_1" {
  type        = string
  description = "CIDR for the private subnet"
  default     = "10.11.1.0/24"
}

# Private Subnet #2
variable "private_subnet_cidr_2" {
  type        = string
  description = "CIDR for the private subnet"
  default     = "10.11.2.0/24"
}

# Private Subnet #3
variable "private_subnet_cidr_3" {
  type        = string
  description = "CIDR for the private subnet"
  default     = "10.11.3.0/24"
}

# Public Subnet
variable "public_subnet_cidr" {
  type        = string
  description = "CIDR for the public subnet"
  default     = "10.11.4.0/24"
}
