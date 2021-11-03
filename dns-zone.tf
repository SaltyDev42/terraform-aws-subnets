resource "aws_route53_zone" "okd" {
  name = var.private_domain
}

resource "aws_route53_zone_association" "okd" {
  for_each = aws_vpc.okd

  zone_id = aws_route53_zone.okd.id
  vpc_id = each.value.id
}
