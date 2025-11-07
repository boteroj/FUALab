data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  public_azs = length(var.availability_zones) > 0 ? slice(var.availability_zones, 0, length(var.public_subnet_cidrs)) : slice(data.aws_availability_zones.available.names, 0, length(var.public_subnet_cidrs))
  private_azs = length(var.availability_zones) > 0 ? slice(var.availability_zones, 0, length(var.private_subnet_cidrs)) : slice(data.aws_availability_zones.available.names, 0, length(var.private_subnet_cidrs))
}

resource "aws_vpc" "this" {
  count                = var.create_vpc ? 1 : 0
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

resource "aws_internet_gateway" "this" {
  count = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.this[0].id

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-igw"
  })
}

resource "aws_subnet" "public" {
  count                   = var.create_vpc ? length(var.public_subnet_cidrs) : 0
  vpc_id                  = aws_vpc.this[0].id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = local.public_azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-public-${count.index}"
    Tier = "public"
  })
}

resource "aws_subnet" "private" {
  count             = var.create_vpc ? length(var.private_subnet_cidrs) : 0
  vpc_id            = aws_vpc.this[0].id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = local.private_azs[count.index]

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-private-${count.index}"
    Tier = "private"
  })
}

resource "aws_eip" "nat" {
  count = var.create_vpc ? 1 : 0
  vpc   = true

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-nat-eip"
  })
}

resource "aws_nat_gateway" "this" {
  count         = var.create_vpc ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [aws_internet_gateway.this]

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-nat"
  })
}

resource "aws_route_table" "public" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.this[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  count          = var.create_vpc ? length(aws_subnet.public) : 0
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table" "private" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.this[0].id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[0].id
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-private-rt"
  })
}

resource "aws_route_table_association" "private" {
  count          = var.create_vpc ? length(aws_subnet.private) : 0
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[0].id
}

locals {
  vpc_id_effective = var.create_vpc ? aws_vpc.this[0].id : var.vpc_id
  public_subnet_ids_effective = var.create_vpc ? aws_subnet.public[*].id : var.public_subnet_ids
  private_subnet_ids_effective = var.create_vpc ? aws_subnet.private[*].id : var.private_subnet_ids
}

