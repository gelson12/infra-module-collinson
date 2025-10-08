
##################################################
# Route tables (one for public, one for private) #
##################################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # Default route for internet via IGW
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, { Name = "${var.name}-public-rt" })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  # Default route for internet via NAT (egress only)
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[0].id
  }

 tags = merge(var.tags, { Name = "${var.name}-private-rt" })
}

#########################################################
# Associate each subnet with its correct RT in one loop #
#########################################################
resource "aws_route_table_association" "assoc" {
  for_each       = aws_subnet.subnets
  subnet_id      = each.value.id
  route_table_id = each.key == "public" ? aws_route_table.public.id : aws_route_table.private.id
}

