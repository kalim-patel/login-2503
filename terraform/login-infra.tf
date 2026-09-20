# VPC
resource "aws_vpc" "login-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "login-vpc"
  }
}

# Web Subnet
resource "aws_subnet" "login-web-sn" {
  vpc_id     = aws_vpc.login-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "login-web-subnet"
  }
}

# API Subnet
resource "aws_subnet" "login-api-sn" {
  vpc_id     = aws_vpc.login-vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "login-api-subnet"
  }
}

# DB Subnet
resource "aws_subnet" "login-db-sn" {
  vpc_id     = aws_vpc.login-vpc.id
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "login-database-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "login-igw" {
  vpc_id = aws_vpc.login-vpc.id

  tags = {
    Name = "login-internet-gateway"
  }
}

# Public Route Table
resource "aws_route_table" "login-pub-rt" {
  vpc_id = aws_vpc.login-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.login-igw.id
  }

  tags = {
    Name = "login-public-rt"
  }
}


# Public Route Table - Web SN ASC
resource "aws_route_table_association" "login-web-sn-asc" {
  subnet_id      = aws_subnet.login-web-sn.id
  route_table_id = aws_route_table.login-pub-rt.id
}

# Public Route Table - API SN ASC
resource "aws_route_table_association" "login-api-sn-asc" {
  subnet_id      = aws_subnet.login-api-sn.id
  route_table_id = aws_route_table.login-pub-rt.id
}

# Private Route Table
resource "aws_route_table" "login-pvt-rt" {
  vpc_id = aws_vpc.login-vpc.id

  tags = {
    Name = "login-private-rt"
  }
}

# Private Route Table - DB SN ASC
resource "aws_route_table_association" "login-db-sn-asc" {
  subnet_id      = aws_subnet.login-db-sn.id
  route_table_id = aws_route_table.login-pvt-rt.id
}

# Web NACL
resource "aws_network_acl" "login-web-nacl" {
  vpc_id = aws_vpc.login-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "login-web-nacl"
  }
}

# Web NACL Association
resource "aws_network_acl_association" "login-web-nacl-asc" {
  network_acl_id = aws_network_acl.login-web-nacl.id
  subnet_id      = aws_subnet.login-web-sn.id
}

# API NACL
resource "aws_network_acl" "login-api-nacl" {
  vpc_id = aws_vpc.login-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "login-api-nacl"
  }
}

# API NACL Association
resource "aws_network_acl_association" "login-api-nacl-asc" {
  network_acl_id = aws_network_acl.login-api-nacl.id
  subnet_id      = aws_subnet.login-api-sn.id
}

# DB NACL
resource "aws_network_acl" "login-db-nacl" {
  vpc_id = aws_vpc.login-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "login-db-nacl"
  }
}

# DB NACL Association
resource "aws_network_acl_association" "login-db-nacl-asc" {
  network_acl_id = aws_network_acl.login-db-nacl.id
  subnet_id      = aws_subnet.login-db-sn.id
}

# Web Security Group
resource "aws_security_group" "login-web-sg" {
  name        = "login-web"
  description = "Allow WebServer Traffic"
  vpc_id      = aws_vpc.login-vpc.id

  tags = {
    Name = "login-web"
  }
}

# Web Security Group - SSH
resource "aws_vpc_security_group_ingress_rule" "login-web-sg-ssh" {
  security_group_id = aws_security_group.login-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Web Security Group - HTTP
resource "aws_vpc_security_group_ingress_rule" "login-web-sg-http" {
  security_group_id = aws_security_group.login-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Web Security Group - Outbound All
resource "aws_vpc_security_group_egress_rule" "login-web-sg-outbound" {
  security_group_id = aws_security_group.login-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  ip_protocol       = "tcp"
  to_port           = 65535
}

# API Security Group
resource "aws_security_group" "login-api-sg" {
  name        = "login-api"
  description = "Allow API Server Traffic"
  vpc_id      = aws_vpc.login-vpc.id

  tags = {
    Name = "login-api"
  }
}

# API Security Group - SSH
resource "aws_vpc_security_group_ingress_rule" "login-api-sg-ssh" {
  security_group_id = aws_security_group.login-api-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# API Security Group - HTTP
resource "aws_vpc_security_group_ingress_rule" "login-api-sg-http" {
  security_group_id = aws_security_group.login-api-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

# API Security Group - Outbound All
resource "aws_vpc_security_group_egress_rule" "login-api-sg-outbound" {
  security_group_id = aws_security_group.login-api-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  ip_protocol       = "tcp"
  to_port           = 65535
}

# DB Security Group
resource "aws_security_group" "login-db-sg" {
  name        = "login-db"
  description = "Allow DB Server Traffic"
  vpc_id      = aws_vpc.login-vpc.id

  tags = {
    Name = "login-db"
  }
}

# DB Security Group - SSH
resource "aws_vpc_security_group_ingress_rule" "login-db-sg-ssh" {
  security_group_id = aws_security_group.login-db-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# DB Security Group - POSTGRES
resource "aws_vpc_security_group_ingress_rule" "login-db-sg-postgres" {
  security_group_id = aws_security_group.login-db-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
}

# DB Security Group - Outbound All
resource "aws_vpc_security_group_egress_rule" "login-db-sg-outbound" {
  security_group_id = aws_security_group.login-db-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  ip_protocol       = "tcp"
  to_port           = 65535
}

# Web Server Instance
resource "aws_instance" "login-web-server" {
  ami           = "ami-0c3b809fcf2445b6a"
  instance_type = "t2.micro"
  key_name      = "aws2603"
  subnet_id     = aws_subnet.login-web-sn.id
  vpc_security_group_ids = [aws_security_group.login-web-sg.id]
  user_data     = file("script.sh")

  tags = {
    Name = "login-web-server"
  }
}
