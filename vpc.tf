#creating a VPC
resource "aws_vpc" "custom-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Customvpc"
  }
}

#creating internet gateway
resource "aws_internet_gateway" "custom-internet-gateway" {
  vpc_id = aws_vpc.custom-vpc.id

  tags = {
    Name = "My-Internet-Gateway"
  }
}

#creating elastic IP address
resource "aws_eip" "custom-elastic-ip" {
  vpc = true
}

#Create a NAT gateway and associate it with an Elastic IP and a public subnet
resource "aws_nat_gateway" "custom-nat-gateway" {
  allocation_id = aws_eip.custom-elastic-ip.id
  subnet_id     = aws_subnet.public-subnet2.id
}

#creating NAT route
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.custom-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.custom-nat-gateway.id
  }

  tags = {
    Name = "My-Custom-Network-Address-Route"
  }
}



#creating public subnet
resource "aws_subnet" "public-subnet1" {
  vpc_id                  = aws_vpc.custom-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "My-public-subnet1"
  }
}

#creating public subnet
resource "aws_subnet" "public-subnet2" {
  vpc_id                  = aws_vpc.custom-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "My-public-subnet2"
  }
}

#creating private subnet
resource "aws_subnet" "private-subnet1" {
  vpc_id                  = aws_vpc.custom-vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "My-private-subnet1"
  }
}

#creating private subnet
resource "aws_subnet" "private-subnet2" {
  vpc_id                  = aws_vpc.custom-vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "My-private-subnet2"
  }
}


#creating route table association
resource "aws_route_table_association" "private_route_table-ass-1" {
  subnet_id      = aws_subnet.private-subnet1.id
  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_route_table_association" "private_route_table-ass-2" {
  subnet_id      = aws_subnet.private-subnet2.id
  route_table_id = aws_route_table.private_route_table.id
}


#creating route table
resource "aws_route_table" "public_route_table" {
  tags = {
    Name = "public_route_table"
  }
  vpc_id = aws_vpc.custom-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom-internet-gateway.id
  }
}

#creating route table association
resource "aws_route_table_association" "public_route_table-ass-1" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.public_route_table.id
}

#creating route table association
resource "aws_route_table_association" "public_route_table-ass-2" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.public_route_table.id
}

#creating public security group
resource "aws_security_group" "Custom-Public-SG-DB" {
  name        = "Custom-Public-SG-DB"
  description = "web and SSH allowed"
  vpc_id      = aws_vpc.custom-vpc.id

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
