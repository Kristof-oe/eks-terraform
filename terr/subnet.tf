resource "aws_subnet" "private_subnet1" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr_block_priv1
  availability_zone = local.zone1

  tags = {
    Name                                                       = "${local.env}-${local.zone1}-priv"
    "kubernetes.io/role/internal-elb"                          = 1
    "kubernetes.io/cluster/${local.env}-${local.eks_name}-eks" = "owned"
  }
}

resource "aws_subnet" "public_subnet1" {

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_block_pub1
  availability_zone       = local.zone1
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name                                                       = "${local.env}-${local.zone1}-pub"
    "kubernetes.io/role/elb"                                   = 1
    "kubernetes.io/cluster/${local.env}-${local.eks_name}-eks" = "owned"
  }
}


resource "aws_subnet" "private_subnet2" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr_block_priv2
  availability_zone = local.zone2

  tags = {
    Name                                                       = "${local.env}-${local.zone2}-priv"
    "kubernetes.io/role/internal-elb"                          = 1
    "kubernetes.io/cluster/${local.env}-${local.eks_name}-eks" = "owned"
  }
}

resource "aws_subnet" "public_subnet2" {

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_block_pub2
  availability_zone       = local.zone2
  map_public_ip_on_launch = var.map_public_ip_on_launch


  tags = {
    Name                                                       = "${local.env}-${local.zone2}-pub"
    "kubernetes.io/role/elb"                                   = 1
    "kubernetes.io/cluster/${local.env}-${local.eks_name}-eks" = "owned"
  }
}