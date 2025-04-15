resource "aws_iam_role" "szakd-node-role" {
  name               = "${local.env}-${local.eks_name}-node-role"
  assume_role_policy = file("./files/node.json")
}


resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {

  role       = aws_iam_role.szakd-node-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {

  role       = aws_iam_role.szakd-node-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {

  role       = aws_iam_role.szakd-node-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

}

resource "aws_eks_node_group" "szakd-node" {

  cluster_name    = aws_eks_cluster.szakd-eks.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.szakd-node-role.arn
  version         = local.eks_version

  subnet_ids = [

    aws_subnet.private_subnet1.id,
    aws_subnet.private_subnet2.id
  ]

  update_config {
    max_unavailable = 1
  }
  capacity_type  = "ON_DEMAND"
  instance_types = [var.instance_types]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1

  }
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  labels = {
    role = var.role
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
  ]

}