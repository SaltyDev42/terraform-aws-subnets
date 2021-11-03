resource "aws_internet_gateway" "okd" {
  for_each = var.vpcs

  vpc_id = aws_vpc.okd[each.key].id
}

resource "aws_route_table" "okd" {
  for_each = var.vpcs

  vpc_id = aws_vpc.okd[each.key].id
  route {
    cidr_block = "0.0.0.0/0" ## destination
    gateway_id = aws_internet_gateway.okd[each.key].id
  }

  tags = {
    Name = "okd-${each.key}-route"
    owner = var.user
  }
}

resource "aws_route_table_association" "okd" {
  for_each = {
    for subnet in local.subnets: "${subnet.env}.${subnet.az}.${subnet.zone}" => subnet
    if subnet.zone == "public"
  }

  subnet_id = aws_subnet.okd[each.key].id
  route_table_id = aws_route_table.okd[each.value.env].id
}
