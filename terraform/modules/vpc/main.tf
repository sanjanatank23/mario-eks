################################
# VPC
################################
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "mario-vpc"
  }
}

################################
# AVAILABILITY ZONES
################################
data "aws_availability_zones" "available" {
  state = "available"
}

################################
# INTERNET GATEWAY
################################
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "mario-igw"
  }
}

################################
# PUBLIC SUBNETS
################################
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "mario-public-${count.index}"

    "kubernetes.io/cluster/mario-eks" = "shared"
    "kubernetes.io/role/elb"          = "1"
  }
}

################################
# ROUTE TABLE (PUBLIC)
################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "mario-public-rt"
  }
}

################################
# ROUTE TABLE ASSOCIATION
################################
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
