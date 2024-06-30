provider "aws" {
  region = "us-east-1" 
}

resource "aws_instance" "strapi" {
  ami           = "ami-01b799c439fd5516a" 
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y nodejs npm git
              sudo npm install -g pm2
              sudo npm install -g strapi@latest
              mkdir -p /srv/strapi
              cd /srv/strapi
              git clone https://github.com/Aditi777613/strapi-ec2-terraform . 
              npm install
              pm2 start npm --name "strapi" -- start
              pm2 save
              EOF

  tags = {
    Name = "StrapiServer"
  }
  
  # Attach necessary IAM role for EC2
  iam_instance_profile = aws_iam_instance_profile.strapi_instance_profile.name
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

resource "aws_iam_role" "strapi_role" {
  name = "strapi_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "strapi_policy_attachment" {
  role       = aws_iam_role.strapi_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_instance_profile" "strapi_instance_profile" {
  name = "strapi_instance_profile"
  role = aws_iam_role.strapi_role.name
}
