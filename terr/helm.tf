data "aws_eks_cluster" "eks" {
  name = aws_eks_cluster.szakd-eks.name

}

data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.szakd-eks.name

}


provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.eks.token

  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks.token

}



resource "helm_release" "alb-controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = aws_eks_cluster.szakd-eks.name
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_eks_pod_identity_association.load-association.role_arn
  }

  set {
    name  = "vpcId"
    value = aws_vpc.main.id
  }
  depends_on = [aws_eks_node_group.szakd-node]
}

resource "helm_release" "argocd" {
  name = "argocd"
  repository = "https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
  chart = "argocd"
  namespace = var.argocd_namespace
  create_namespace = true
  version = var.argocd_version

  set{
    name = "server.service.tpye"
    value = "LoadBalancer"
  }
  
}

# resource "helm_release" "karpenter-karpenter" {
#   name             = "karpenter"
#   repository       = "oci://public.ecr.aws/karpenter/karpenter"
#   chart            = "karpenter"
#   namespace        = var.karpenter_namespace
#   version          = var.karpenter_version
#   create_namespace = true
#   cleanup_on_fail  = true

#   set {
#     name  = "settings.clusterName"
#     value = aws_eks_cluster.szakd-eks.name
#   }

#   set {
#     name  = "settings.interruptionQueue"
#     value = aws_sqs_queue.karpenter.name
#   }

#   set {
#     name  = "controller.resources.requests.cpu"
#     value = "1"
#   }

#   set {
#     name  = "controller.resources.requests.memory"
#     value = "1Gi"
#   }

#   set {
#     name  = "controller.resources.limits.cpu"
#     value = "1"
#   }

#   set {
#     name  = "controller.resources.limits.memory"
#     value = "1Gi"
#   }


#   set {
#     name  = "serviceAccount.name"
#     value = "karpenter"
#   }

#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = aws_iam_role.karpenter-controller.arn
#   }


#   depends_on = [aws_eks_node_group.szakd-node]

# }

resource "helm_release" "efs-csi-driver" {
  name       = "aws-efs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  chart      = "aws-efs-csi-driver"
  namespace  = "kube-system"

  set {
    name  = "controller.serviceAccount.name"
    value = "efs-csi-controller-sa"
  }

  set {

    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.efs-role.arn
  }

  depends_on = [aws_efs_mount_target.zone1, aws_efs_mount_target.zone2]

}


resource "helm_release" "prometheus" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true

  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
    value = false
  }
}
