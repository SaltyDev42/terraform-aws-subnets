data "aws_availability_zones" "az" {
  state = "available"
}

locals {
  subnets = flatten([
    for env,vpc in var.vpcs: [
      for i in range(0, length(vpc.zones)): [
        for j in range(0, length(data.aws_availability_zones.az.names)): {
          zone       = vpc.zones[i]
          env        = env
          cidr_block = cidrsubnet(vpc.cidr_block, 4,
            j+i*length(data.aws_availability_zones.az.names))
          az         = data.aws_availability_zones.az.names[j]
          vpc_id     = aws_vpc.okd[env].id
        }
      ]
    ]
  ])
}

resource "aws_subnet" "okd" {
  for_each = {
    for subnet in local.subnets: "${subnet.env}.${subnet.az}.${subnet.zone}" => subnet
  }

  vpc_id = each.value.vpc_id
  availability_zone = each.value.az
  cidr_block = each.value.cidr_block

  tags = {
    Name = "okd-${each.key}-subnet"
    owner = var.user
  }
}

# resource "aws_subnet" "okd_private" {
#   for_each = var.vpcs.okd.subnets.private

#   cidr_block = each.key.cidr_block
#   availability_zone = each.key.az
#   vpc_id = aws_vpc.okd["okd"].id
# }

# resource "aws_subnet" "okd_public" {
#   for_each = var.vpcs.okd.subnets.public

#   cidr_block = each.key.cidr_block
#   availability_zone = each.key.az
#   vpc_id = aws_vpc.okd["okd"].id
# }

# resource "aws_subnet" "sre" {
#   for_each = var.vpcs.sre.subnets.public

#   cidr_block = each.key.cidr_block
#   availability_zone = each.key.az
#   vpc_id = aws_vpc.okd["sre"].id
# }

