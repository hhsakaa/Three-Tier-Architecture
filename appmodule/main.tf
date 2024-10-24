resource "aws_instance" "appec2" {
  ami                    = "ami-0440d3b780d96b29d"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.app-sg.id]
  key_name               = "tf-key-pair"
  subnet_id              = var.appsubnet_id
  tags = {
    Name = "app-inst"
  }
}

resource "aws_security_group" "app-sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["10.0.16.0/20"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}