resource "aws_route53_zone" "main" {
  name = var.private_domain
}

resource "aws_route53_zone_association" "main" {
  for_each = aws_vpc.main

  zone_id = aws_route53_zone.main.id
  vpc_id = each.value.id
}
