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
          vpc_id     = aws_vpc.main[env].id
        }
      ]
    ]
  ])
}

resource "aws_subnet" "main" {
  for_each = {
    for subnet in local.subnets: "${subnet.env}.${subnet.az}.${subnet.zone}" => subnet
  }

  vpc_id = each.value.vpc_id
  availability_zone = each.value.az
  cidr_block = each.value.cidr_block

  tags = {
    Name = "main-${each.key}-subnet"
    owner = var.user
  }
}
