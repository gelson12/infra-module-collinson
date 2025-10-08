terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

##################################
#             VPC                #
##################################
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = merge(var.tags, { Name = "${var.name}-vpc" })
}
#########################################
# Internet Gateway (attaches via vpc_id)#
#########################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "${var.name}-igw" })
}
#########################################
# NAT (public egress for private subnet)#
#########################################
resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = { Name = "main-nat-eip" }
}
# NAT Gateway must live in the PUBLIC subnet
resource "aws_nat_gateway" "nat" {
  count = var.enable_nat ? 1 : 0
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.subnets["public"].id
  # Ensures the IGW exists before we try to route out (not strictly required, but safe)
  depends_on = [aws_internet_gateway.igw]
  tags       = merge(var.tags, { Name = "${var.name}-nat" })
}