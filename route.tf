resource "aws_internet_gateway" "main" {
  for_each = var.vpcs

  vpc_id = aws_vpc.main[each.key].id
}

resource "aws_route_table" "main" {
  for_each = var.vpcs

  vpc_id = aws_vpc.main[each.key].id
  route {
    cidr_block = "0.0.0.0/0" ## destination
    gateway_id = aws_internet_gateway.main[each.key].id
  }

  tags = {
    Name = "main-${each.key}-route"
    owner = var.user
  }
}

resource "aws_route_table_association" "main" {
  for_each = {
    for subnet in local.subnets: "${subnet.env}.${subnet.az}.${subnet.zone}" => subnet
    if subnet.zone == "public"
  }

  subnet_id = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.main[each.value.env].id
}
