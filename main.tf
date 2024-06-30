provider "aws" {
  region = "us-west-2"  # Replace with your desired AWS region
}

resource "aws_instance" "strapi" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with your desired AMI ID
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y nodejs npm git
              sudo npm install -g pm2
              sudo npm install -g strapi@latest
              mkdir -p /srv/strapi
              cd /srv/strapi
              git clone https://github.com/your-username/your-strapi-repo.git .
              npm install
              pm2 start npm --name "strapi" -- start
              pm2 save
              EOF

  tags = {
    Name = "StrapiServer"
  }
}

resource "aws_security_group" "strapi_sg" {
  name        = "strapi_sg"
  description = "Allow HTTP and SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
