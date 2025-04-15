
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

data "aws_iam_policy_document" "karpenter-policy-document" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.open_id.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:karpenter:karpenter"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.open_id.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "karpenter-controller" {
  name               = "karpenter-controller"
  assume_role_policy = data.aws_iam_policy_document.karpenter-policy-document.json
}

resource "aws_iam_role" "karpenter_node" {
  name               = "karpenter-node"
  assume_role_policy = file("./files/node.json")
}

resource "aws_iam_role_policy" "karpenter-controller" {
  name = "karpenter-controller-policy"
  role = aws_iam_role.karpenter-controller.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Karpenter"
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ec2:DescribeImages",
          "ec2:RunInstances",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DeleteLaunchTemplate",
          "ec2:CreateTags",
          "ec2:CreateLaunchTemplate",
          "ec2:CreateFleet",
          "ec2:DescribeSpotPriceHistory",
          "pricing:GetProducts"
        ]
        Resource = "*"
      },
      {
        Sid      = "ConditionalEC2Termination"
        Effect   = "Allow"
        Action   = "ec2:TerminateInstances"
        Resource = "*"
        Condition = {
          StringLike = {
            "ec2:ResourceTag/karpenter.sh/nodepool" = "*"
          }
        }
      },
      {
        Sid    = "PassNodeIAMRole"
        Effect = "Allow"
        Action = "iam:PassRole"
        Resource = [
          aws_iam_role.szakd-node-role.arn,
          aws_iam_role.karpenter_node.arn
        ]
      },
      {
        Sid      = "EKSClusterEndpointLookup"
        Effect   = "Allow"
        Action   = "eks:DescribeCluster"
        Resource = aws_eks_cluster.szakd-eks.arn
      },
      {
        Sid      = "AllowScopedInstanceProfileCreationActions"
        Effect   = "Allow"
        Resource = "*"
        Action = [
          "iam:CreateInstanceProfile"
        ]
        Condition = {
          StringEquals = {
            "aws:RequestTag/kubernetes.io/cluster/${aws_eks_cluster.szakd-eks.name}" = "owned"
            "aws:RequestTag/topology.kubernetes.io/region"                           = local.region
          }
          StringLike = {
            "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass" = "*"
          }
        }
      },
      {
        Sid      = "AllowScopedInstanceProfileTagActions"
        Effect   = "Allow"
        Resource = "*"
        Action = [
          "iam:TagInstanceProfile"
        ]
        Condition = {
          StringEquals = {
            "aws:ResourceTag/kubernetes.io/cluster/${aws_eks_cluster.szakd-eks.name}" = "owned"
            "aws:ResourceTag/topology.kubernetes.io/region"                           = local.region
            "aws:RequestTag/kubernetes.io/cluster/${aws_eks_cluster.szakd-eks.name}"  = "owned"
            "aws:RequestTag/topology.kubernetes.io/region"                            = local.region
          }
          StringLike = {
            "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass" = "*"
            "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass"  = "*"
          }
        }
      },
      {
        Sid      = "AllowScopedInstanceProfileActions"
        Effect   = "Allow"
        Resource = "*"
        Action = [
          "iam:AddRoleToInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:DeleteInstanceProfile"
        ]
        Condition = {
          StringEquals = {
            "aws:ResourceTag/kubernetes.io/cluster/${aws_eks_cluster.szakd-eks.name}" = "owned"
            "aws:ResourceTag/topology.kubernetes.io/region"                           = local.region
          }
          StringLike = {
            "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass" = "*"
          }
        }
      },
      {
        Sid      = "AllowInstanceProfileReadActions"
        Effect   = "Allow"
        Resource = "*"
        Action   = "iam:GetInstanceProfile"
      },
      {
        Sid    = "AllowSQSActions"
        Effect = "Allow"
        Action = [
          "sqs:DeleteMessage",
          "sqs:GetQueueUrl",
          "sqs:GetQueueAttributes",
          "sqs:ReceiveMessage"
        ]
        Resource = aws_sqs_queue.karpenter.arn
      }
    ]
  })

}



resource "aws_iam_instance_profile" "karpenter" {
  name = "KarpenterNodeIn"
  role = aws_iam_role.karpenter_node.name

}

resource "aws_sqs_queue_policy" "karpenter" {
  queue_url = aws_sqs_queue.karpenter.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.karpenter.arn
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "sqs.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.karpenter.arn
      }
    ]
  })

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