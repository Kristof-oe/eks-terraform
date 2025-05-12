
resource "aws_iam_role" "load-role" {
  name               = "${aws_eks_cluster.szakd-eks.name}-load-balancer"
  assume_role_policy = file("./files/pod.json")

}

resource "aws_iam_policy" "load-policy" {
  name        = "aws-load-balancer-controller"
  description = "This is the policy"
  policy      = file("./files/policy.json")

}

resource "aws_iam_role_policy_attachment" "load-policy-attach" {
  policy_arn = aws_iam_policy.load-policy.arn
  role       = aws_iam_role.load-role.name

}

resource "aws_eks_pod_identity_association" "load-association" {
  cluster_name    = aws_eks_cluster.szakd-eks.name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = aws_iam_role.load-role.arn
}

data "aws_iam_policy_document" "efs_csi_driver" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.open_id.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:efs-csi-controller-sa"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.open_id.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "efs-role" {
  name               = "${local.env}-${local.eks_name}-efs"
  assume_role_policy = data.aws_iam_policy_document.efs_csi_driver.json
}

resource "aws_iam_role_policy_attachment" "efs-policy" {

  role       = aws_iam_role.efs-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"

}


data "aws_iam_policy_document" "autoscaler-policy-document" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.open_id.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler-sa"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.open_id.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "autoscaler-role" {
  name               = "${aws_eks_cluster.szakd-eks.name}-autoscaler"
  assume_role_policy = data.aws_iam_policy_document.autoscaler-policy-document.json
}

resource "aws_iam_policy" "autoscaler" {
  name = "eks-cluster-autoscaler"

  policy = jsonencode({
    Statement = [{
      Action = [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeTags",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ec2:DescribeLaunchTemplateVersions",
        "ec2:RunInstances",
        "ec2:TerminateInstances"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "autoscaler_attach" {

  role       = aws_iam_role.autoscaler-role.name
  policy_arn = aws_iam_policy.autoscaler.arn
}

data "tls_certificate" "open_id" {

  url = aws_eks_cluster.szakd-eks.identity[0].oidc[0].issuer

}

resource "aws_iam_openid_connect_provider" "open_id" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.open_id.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.szakd-eks.identity[0].oidc[0].issuer

  depends_on = [aws_eks_cluster.szakd-eks]
}