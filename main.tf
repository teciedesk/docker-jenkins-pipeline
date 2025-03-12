provider "aws" {
  region = "us-west-1" # Change this to your preferred region
}

resource "aws_instance" "jenkins" {
  ami           = "ami-07d2649d67dbe8900"
  instance_type = "t2.medium"
  key_name      = "docker-jenkins-key"
  security_groups = [aws_security_group.jenkins_sg.name]

  tags = {
    Name = "Jenkins-Server"
  }
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Security group for jenkins"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Jenkins Web UI
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


