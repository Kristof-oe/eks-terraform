resource "aws_efs_file_system" "data" {

    creation_token = "${local.env}-data"

    tags = {
      Name = "${local.env}-data"
    }
  
}

resource "aws_efs_mount_target" "zona-1" {

    file_system_id = aws_efs_file_system.data.id
    subnet_id =aws_subnet.private_zone1.id
    security_groups = [aws_eks_cluster.szakd-eks.vpc_config[0].cluster_security_group_id]

}

resource "aws_efs_mount_target" "zona-2" {

    file_system_id = aws_efs_file_system.data.id
    subnet_id =aws_subnet.private_zone2.id
    security_groups = [aws_eks_cluster.szakd-eks.vpc_config[0].cluster_security_group_id]

}

data "aws_iam_policy_document" "efs_csi_driver" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:efs-csi-controller-sa"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "efs_csi_driver" {

    name = "${aws_eks_cluster.szakd-eks.name}-efs-csi-driver"
    assume_role_policy = data.aws_iam_policy_document.efs_csi_driver.json
  
}

resource "aws_iam_role_policy_attachment" "efs_csi_driver" {
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
    role       = aws_iam_role.efs_csi_driver.name
}

# resource "aws_security_group" "allow-efs" {
  
#   name= "${local.env}-allow-efs-sg"
#   vpc_id = aws_vpc.szakd-vpc.id

#   ingress {

#     from_port = 2049
#     to_port = 2049
#     protocol = "tcp"
#     cidr_blocks = [aws_subnet.private_zone1.cidr_block, aws_subnet.private_zone2.cidr_block]
#   }

#   tags = {

#     "Name" = "Allow EFS access for ${local.env}"
#   } 
# }

resource "kubernetes_storage_class_v1" "efs_storage" {
  metadata {
    name = "efs"
  }

  storage_provisioner = "efs.csi.aws.com"

  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId     = aws_efs_file_system.data.id
    directoryPerms   = "700"
  }

  mount_options = ["iam"]

  depends_on = [helm_release.efs_csi_driver]
}