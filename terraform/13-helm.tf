data "aws_eks_cluster" "eks" {
  name = aws_eks_cluster.szakd-eks.name
}

data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.szakd-eks.name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}


resource "helm_release" "alb_ingress_controller" {
    name       = "aws-load-balancer-controller"
    repository = "http://aws.github.io/eks-charts"
    chart      = "aws-load-balancer-controller"
    namespace  = "kube-system"
    version    = "1.9"

    
    set {
        name  = "clusterName"
        value = aws_eks_cluster.szakd-eks.name
    }

    set {
        name= "serviceAccount.name"
        value = aws_eks_pod_identity_association.aws_lbc.service_account
    }

    set {
      name = "vpcId"
      value = aws_vpc.szakd-vpc.id
    }

    set {
      name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_eks_pod_identity_association.aws_lbc.role_arn
    } 

    depends_on = [ aws_eks_node_group.general]

}

resource "helm_release" "efs_csi_driver" {
    name       = "aws-efs-csi-driver"
    repository = "http://kubernetes-sigs.github.io/aws-efs-csi-driver/"
    chart      = "aws-efs-csi-driver"
    namespace  = "kube-system"
    version    = "3.1.7"
    
    set {
        name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
        value = aws_iam_role.efs_csi_driver.arn
    }

    set {
        name="contoller.serviceAccount.name"
        value = "efs-csi-controller-sa"
    }

    depends_on = [ aws_efs_mount_target.zona-1, aws_efs_mount_target.zona-2 ]

}

