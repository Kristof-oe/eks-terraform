
resource "local_file" "gitops" {
  content = templatefile("${path.module}/argo_gitops/standard/4_nodeclass.yaml", {
    create_namespace   = true
    cleanup_on_fail    = true
    chart              = "karpenter"
    cluster_name       = aws_eks_cluster.szakd-eks.name
    namespace          = var.karpenter_namespace
    version            = var.karpenter_version
    interruptionQueue  = aws_sqs_queue.karpenter.name
    reqcpu             = 1
    reqmemory          = "1Gi"
    limitcpu           = 1
    limitmemory        = "1Gi"
    serviceAccountname = "karpenter"
    serviceAccountarn  = aws_iam_role.karpenter-controller.arn

    eks                = aws_eks_cluster.szakd-eks
    instance_profile   = aws_iam_instance_profile.karpenter.name
    kubernetes_version = aws_eks_cluster.szakd-eks.version
    environment        = local.env
  })
  filename = "${path.module}/argo_gitops/karpenter/templates/4_nodeclass.yaml"

}

resource "local_file" "gitops1" {
  content = templatefile("${path.module}/argo_gitops/standard/5_nodepool.yaml", {
    create_namespace   = true
    cleanup_on_fail    = true
    chart              = "karpenter"
    cluster_name       = aws_eks_cluster.szakd-eks.name
    namespace          = var.karpenter_namespace
    version            = var.karpenter_version
    interruptionQueue  = aws_sqs_queue.karpenter.name
    reqcpu             = 1
    reqmemory          = "1Gi"
    limitcpu           = 1
    limitmemory        = "1Gi"
    serviceAccountname = "karpenter"
    serviceAccountarn  = aws_iam_role.karpenter-controller.arn

    eks                = aws_eks_cluster.szakd-eks
    instance_profile   = aws_iam_instance_profile.karpenter.name
    kubernetes_version = aws_eks_cluster.szakd-eks.version
    environment        = local.env
  })
  filename = "${path.module}/argo_gitops/karpenter/templates/5_nodepool.yaml"

}

resource "local_file" "gitops3" {
  content = templatefile("${path.module}/argo_gitops/standard/app_helm.yaml", {
    create_namespace   = true
    cleanup_on_fail    = true
    chart              = "karpenter"
    cluster_name       = aws_eks_cluster.szakd-eks.name
    namespace          = var.karpenter_namespace
    version            = var.karpenter_version
    interruptionQueue  = aws_sqs_queue.karpenter.name
    reqcpu             = 1
    reqmemory          = "1Gi"
    limitcpu           = 1
    limitmemory        = "1Gi"
    serviceAccountname = "karpenter"
    serviceAccountarn  = aws_iam_role.karpenter-controller.arn

    eks                = aws_eks_cluster.szakd-eks
    instance_profile   = aws_iam_instance_profile.karpenter.name
    kubernetes_version = aws_eks_cluster.szakd-eks.version
    environment        = local.env
  })
  filename = "${path.module}/argo_gitops/karpenter/app_helm.yaml"

}


resource "local_file" "gitops4" {
  content = templatefile("${path.module}/argo_gitops/standard/app_monitor.yaml", {
    create_namespace   = true
    cleanup_on_fail    = true
    chart              = "karpenter"
    cluster_name       = aws_eks_cluster.szakd-eks.name
    namespace          = var.karpenter_namespace
    version            = var.karpenter_version
    interruptionQueue  = aws_sqs_queue.karpenter.name
    reqcpu             = 1
    reqmemory          = "1Gi"
    limitcpu           = 1
    limitmemory        = "1Gi"
    serviceAccountname = "karpenter"
    serviceAccountarn  = aws_iam_role.karpenter-controller.arn

    eks                = aws_eks_cluster.szakd-eks
    instance_profile   = aws_iam_instance_profile.karpenter.name
    kubernetes_version = aws_eks_cluster.szakd-eks.version
    environment        = local.env
  })
  filename = "${path.module}/argo_gitops/karpenter/monitor/app_monitor.yaml"

}


