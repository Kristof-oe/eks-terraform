
resource "local_file" "gitops" {
    content = templatefile("${path.module}/gitrepo/app_helm.yaml.tpl", {
        create_namespace=true
        cleanup_on_fail=true
        chart="karpenter"
        cluster_name= aws_eks_cluster.szakd-eks.name
        namespace = var.karpenter_namespace
        version          = var.karpenter_version
        interruptionQueue=aws_sqs_queue.karpenter.name
        reqcpu=1
        reqmemory="1Gi"
        limitcpu=1
        limitmemory="1Gi"
        serviceAccountname="karpenter"
        serviceAccountarn=aws_iam_role.karpenter-controller.arn

        eks= aws_eks_cluster.szakd-eks
        instance_profile=aws_iam_instance_profile.karpenter.name
        kubernetes_version=aws_eks_cluster.szakd-eks.version
        environment=local.env
    })
    filename = "${path.module}/gitrepo/output/output.yaml"
  
}

resource "local_file" "gitops1" {
    content = templatefile("${path.module}/gitrepo/app_node.yaml.tpl", {
        create_namespace=true
        cleanup_on_fail=true
        chart="karpenter"
        cluster_name= aws_eks_cluster.szakd-eks.name
        namespace = var.karpenter_namespace
        version          = var.karpenter_version
        interruptionQueue=aws_sqs_queue.karpenter.name
        reqcpu=1
        reqmemory="1Gi"
        limitcpu=1
        limitmemory="1Gi"
        serviceAccountname="karpenter"
        serviceAccountarn=aws_iam_role.karpenter-controller.arn

        eks= aws_eks_cluster.szakd-eks
        instance_profile=aws_iam_instance_profile.karpenter.name
        kubernetes_version=aws_eks_cluster.szakd-eks.version
        environment=local.env
    })
    filename = "${path.module}/gitrepo/output/output.yaml"
  
}


