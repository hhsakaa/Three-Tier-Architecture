resource "aws_instance" "webec2" {
 associate_public_ip_address = true
  ami               = "ami-0440d3b780d96b29d"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name = "tf-key-pair"
  subnet_id = var.websubnet_id
  tags = {
    Name = "web-inst"
  }
    user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install nginx -y
    service nginx start
    cd /usr/share/nginx/html
    touch index.html
    echo "hello from terraform" > index.html
    EOF
 }
 

resource "aws_security_group" "web-sg" {
  vpc_id = var.vpc_id
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
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}