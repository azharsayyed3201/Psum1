#creating EC2 instance
resource "aws_instance" "My-web-instance1" {
  ami                         = "ami-0f5ee92e2d63afc18" 
  key_name                    = "mykeypair"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public-subnet1.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.Custom-Public-SG-DB.id]
  user_data                   = <<-EOF
        #!/bin/bash
        sudo apt-get udpate -y
        touch a 
        sudo apt-get install nginx -y
        touch b
        sudo systemctl start nginx
        touch c
        sudo systemctl enable nginx 
        touch d
        sudo systemctl status nginx
        touch e
        cd /var/www/html
        sudo echo "Hey azzy" > /var/www/html/index.html
        sudo apt install curl -y
        sudo curl -SSL https://get.docker.com/ | sh
        EOF
}

