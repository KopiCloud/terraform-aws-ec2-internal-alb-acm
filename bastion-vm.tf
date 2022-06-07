########################################
## Bastion Machine Module - Variables ##
########################################

variable "bastion_instance_type" {
  type        = string
  description = "EC2 instance type for Windows Server"
  default     = "t3.micro"
}

###################################
## Bastion Machine Module - Main ##
###################################

# Get latest Windows Server 2022 AMI
data "aws_ami" "windows-2022" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base*"]
  }
}

# Create Bastion Server
resource "aws_instance" "bastion-server" {
  ami                         = data.aws_ami.windows-2022.id
  instance_type               = var.bastion_instance_type
  subnet_id                   = aws_subnet.public-subnet.id
  vpc_security_group_ids      = [aws_security_group.bastion-sg.id]
  associate_public_ip_address = true
  source_dest_check           = false
  key_name                    = aws_key_pair.key_pair.key_name
  
  tags = {
    Name        = "${lower(var.app_name)}-${var.app_environment}-bastion"
    Environment = var.app_environment
  }
}

# Create Elastic IP for the Bastion
resource "aws_eip" "bastion-eip" {
  vpc  = true
  tags = {
    Name        = "${lower(var.app_name)}-${var.app_environment}-bastion-eip"
    Environment = var.app_environment
  }
}

# Associate Elastic IP to Bastion Server
resource "aws_eip_association" "bastion-eip-association" {
  instance_id   = aws_instance.bastion-server.id
  allocation_id = aws_eip.bastion-eip.id
}

# Define the security group for the Bastion server
resource "aws_security_group" "bastion-sg" {
  name        = "${lower(var.app_name)}-${var.app_environment}-bastion-sg"
  description = "Allow incoming connections"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming RDP connections"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${lower(var.app_name)}-${var.app_environment}-bastion-sg"
    Environment = var.app_environment
  }
}

#####################################
## Virtual Machine Module - Output ##
#####################################

output "bastion_server_instance_id" {
  value = aws_instance.bastion-server.id
}

output "bastion_server_instance_public_dns" {
  value = aws_instance.bastion-server.public_dns
}

output "bastion_server_instance_public_ip" {
  value = aws_eip.bastion-eip.public_ip
}

output "bastion_server_instance_private_ip" {
  value = aws_instance.bastion-server.private_ip
}
