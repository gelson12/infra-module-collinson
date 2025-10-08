locals {
  subnet_map = {
    public  = { cidr = var.public_subnet_cidr,  az = var.az }
    private = { cidr = var.private_subnet_cidr, az = var.az }
  }
}


################################
# Subnets (one block, looped) #
################################
resource "aws_subnet" "subnets" {
  for_each          = local.subnet_map
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  # When looping through the for_each subnets (public and private), this conditional expression checks if the current subnet’s key is "public"
  map_public_ip_on_launch = each.key == "public" ? true : false

  tags = merge(var.tags, { Name = "${var.name}-${each.key}-subnet" })
}
