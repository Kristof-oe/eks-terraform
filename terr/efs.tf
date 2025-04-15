resource "aws_efs_file_system" "file" {
  creation_token = "${local.env}-data"

  tags = {
    name = "${local.env}-data"
  }
}

resource "aws_efs_mount_target" "zone1" {
  file_system_id  = aws_efs_file_system.file.id
  subnet_id       = aws_subnet.private_subnet1.id
  security_groups = [aws_eks_cluster.szakd-eks.vpc_config[0].cluster_security_group_id]


}

resource "aws_efs_mount_target" "zone2" {
  file_system_id  = aws_efs_file_system.file.id
  subnet_id       = aws_subnet.private_subnet2.id
  security_groups = [aws_eks_cluster.szakd-eks.vpc_config[0].cluster_security_group_id]

}

resource "kubernetes_storage_class_v1" "efs_storage" {
  metadata {
    name = "efs"
  }

  storage_provisioner = "efs.csi.aws.com"

  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId     = aws_efs_file_system.file.id
    directoryPerms   = "700"
  }

  mount_options = ["iam"]
  depends_on    = [helm_release.efs-csi-driver]

}
