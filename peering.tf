resource "aws_vpc_peering_connection" "main" {
  for_each = var.peers

  vpc_id = aws_vpc.main[each.value.requester.env].id
  peer_vpc_id = aws_vpc.main[each.value.accepter.env].id
  peer_region = each.value.accepter.region
  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = {
    Name = "main-${each.key}-peers"
    owner = var.user
  }
}
