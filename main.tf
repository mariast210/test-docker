# Specify the provider (AWS in this case)
provider "aws" {
  region = "us-east-1"
}

# Define the resource: an EC2 instance
resource "aws_instance" "my_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI ID
  instance_type = "t2.micro"

  # Tag the instance
  tags = {
    Name = "MyFirstInstance"
  }

  # Security group to allow SSH (port 22)
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  # User data to run on instance launch
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > /var/www/html/index.html
              EOF
}

# Create a security group to allow SSH access
resource "aws_security_group" "my_sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow access from any IP address
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Output the instance's public IP
output "instance_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.my_instance.public_ip
}
