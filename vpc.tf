resource "aws_vpc" "okd" {
  for_each = var.vpcs

  cidr_block = each.value.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "okd-${each.key}-vpc"
    owner = var.user
  }
}
