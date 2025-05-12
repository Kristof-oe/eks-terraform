resource "aws_iam_role" "szakd-eks-role" {
  name               = "${local.env}-${local.eks_name}-eks-role"
  assume_role_policy = file("./files/eks.json")
}

resource "aws_iam_role_policy_attachment" "szakd-eks" {

  role       = aws_iam_role.szakd-eks-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

}

resource "aws_eks_cluster" "szakd-eks" {

  name     = "${local.env}-${local.eks_name}-eks"
  role_arn = aws_iam_role.szakd-eks-role.arn
  version  = local.eks_version




  access_config {
    authentication_mode                         = var.authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions
  }

  vpc_config {

    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access

    subnet_ids = [
      aws_subnet.private_subnet1.id,
      aws_subnet.private_subnet2.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.szakd-eks]

}

