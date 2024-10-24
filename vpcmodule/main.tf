resource "aws_vpc" "customevpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "custom-vpc"
  }
}

resource "aws_internet_gateway" "custom-igw" {
  vpc_id = aws_vpc.customevpc.id

  tags = {
    Name = "custom-igw"
  }
}

resource "aws_subnet" "websubnet" {
  vpc_id            = aws_vpc.customevpc.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "us-east-1a"
  tags = {
    Name = "web-subnet"
  }
}

resource "aws_subnet" "appsubnet" {
  vpc_id            = aws_vpc.customevpc.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "us-east-1b"
  tags = {
    Name = "app-subnet"
  }
}

resource "aws_subnet" "dbsubnet" {
  vpc_id            = aws_vpc.customevpc.id
  cidr_block        = "10.0.32.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "db-subnet"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.customevpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom-igw.id
  }
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "pub-rt"
  }
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.customevpc.id
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "pvt-rt"
  }
}

resource "aws_route_table_association" "web-association" {
  subnet_id      = aws_subnet.websubnet.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "app-association" {
  subnet_id      = aws_subnet.appsubnet.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "db-association" {
  subnet_id      = aws_subnet.dbsubnet.id
  route_table_id = aws_route_table.private-rt.id
}
