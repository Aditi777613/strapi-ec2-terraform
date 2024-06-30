provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "strapi" {
  ami           = "ami-04b70fa74e45c3917"  
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
}
